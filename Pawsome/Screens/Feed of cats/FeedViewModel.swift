//
//  FeedViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 04.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

// MARK: - Feed model
class Feed {
    var urls : [String] = []
}

protocol FeedViewModelProtocol : class {
    /// List of all urls for current session
    var urls : [String] { get }
    
    /// Call clousure if imagesList has changed
    var imagesListDidChange : ((FeedViewModelProtocol) -> ())? {get set}
    
    /// Image for specific index is loaded
    var imageForIndexDidLoad : ((IndexPath) -> ())? {get set}
    
    /// Tell viewModel to upload more images and display them in feed
    func showNewImages()
    
    /// Get cached images
    func image(for index: Int, with indexPath: IndexPath) -> UIImage?
}

class FeedViewModel : FeedViewModelProtocol {
    private let feed : Feed
    private let networkService : NetworkService
    private var imagesCount = 0 {
        didSet {
            if imagesCount == 15, let saveResult = imagesListDidChange {
                saveResult(self)
            }
        }
    }
    private var cachedImages = NSCache<AnyObject, UIImage>() {
        didSet {
            if let saveResult = imagesListDidChange {
                saveResult(self)
            }
        }
    }
    
    var imagesListDidChange : ((FeedViewModelProtocol) -> ())?
    var imageForIndexDidLoad : ((IndexPath) -> ())?
    
    var urls : [String] = []
    
    init(feed : Feed, networkService: NetworkService = NetworkServiceImplementation()) {
        self.feed = feed
        self.networkService = networkService
        cachedImages.countLimit = 150
        loadImagesUrls()
    }
    
    private func loadImagesUrls() {
        imagesCount = 0
        networkService.getRandomCatImages { [weak self] (imagesList) in
            print(imagesList)
            guard let self = self else { fatalError() }
            self.urls.append(contentsOf: imagesList)
            imagesList.forEach {
                guard let index = self.urls.firstIndex(of: $0) else { fatalError() }
                self.networkService.downloadImage(atUrl: $0) { (image) in
                    self.cachedImages.setObject(image!, forKey: index as AnyObject)
                    self.imagesCount += 1
                }
            }
        }
    }
    
    func image(for index: Int, with indexPath: IndexPath) -> UIImage? {
        if let image = cachedImages.object(forKey: index as AnyObject) {
            return image
        } else {
            networkService.downloadImage(atUrl: urls[index]) { [weak self] (image) in
                guard let self = self, let callbackForImage = self.imageForIndexDidLoad else { fatalError() }
                self.cachedImages.setObject(image!, forKey: index as AnyObject)
                callbackForImage(indexPath)
            }
        }
        return nil
    }
    
    func showNewImages() {
        loadImagesUrls()
    }
}
