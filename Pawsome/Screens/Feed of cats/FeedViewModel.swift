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
    func getImage(for index: Int, with indexPath: IndexPath, complition: @escaping (UIImage?) -> Void)
    
    /// Delete all images from canvas and refresh urls list
    func removeAllImages()
    
    /// Get site URL for selected image
    func urlForPressedImage(at index : Int) -> String
}

class FeedViewModel : FeedViewModelProtocol {
    private let feed : Feed
    private let batchCount = 18
    private let networkService : NetworkService
    private let fileManagerService : FileManagerService
    var imagesListDidChange : ((FeedViewModelProtocol) -> ())?
    var imageForIndexDidLoad : ((IndexPath) -> ())?
    var urls : [String] = [] {
        didSet {
            if urls.count > 0 && urls.count % batchCount == 0, let saveResult = imagesListDidChange {
                saveResult(self)
            }
        }
    }
    
    init(feed : Feed,
         networkService: NetworkService = AppDelegate.shared.context.networkService,
         fileManagerService: FileManagerService = AppDelegate.shared.context.fileManagerService) {
        self.feed = feed
        self.networkService = networkService
        self.fileManagerService = fileManagerService
        loadImagesUrls()
    }
    
    private func loadImagesUrls() {
        networkService.getRandomCatImages(imgCount: 18) { [weak self] (imagesList) in
            guard let self = self else { fatalError() }
            imagesList.forEach { imageUrl in
                self.networkService.downloadImage(atUrl: imageUrl) { (image, data) in
                    self.fileManagerService.saveImage(data, at: imageUrl, onSuccess: {
                        self.urls.append(imageUrl)
                    })
                }
            }
        }
    }
    
    func getImage(for index: Int, with indexPath: IndexPath, complition: @escaping (UIImage?) -> Void) {
        fileManagerService.fetchImage(at: urls[index]) { (image) in
            complition(image)
        }
    }
    
    func showNewImages() {
        loadImagesUrls()
    }
    
    func removeAllImages() {
        let urlCopy = urls
        urls.removeAll()
        fileManagerService.deleteAllItems(at: urlCopy)
    }
    
    func urlForPressedImage(at index : Int) -> String {
        return urls[index]
    }
}
