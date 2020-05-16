//
//  FeedViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 04.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

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
    /// Check if previous fetch is canceled before send one more request
    var canPrefetchMoreItems : Bool { get }
}

class FeedViewModel : FeedViewModelProtocol {
    private let batchCount = 18
    private let networkService : NetworkService
    private let fileManagerService : FileManagerService
    var imagesListDidChange : ((FeedViewModelProtocol) -> ())?
    var imageForIndexDidLoad : ((IndexPath) -> ())?
    var canPrefetchMoreItems : Bool { urls.count > 0 && urls.count % batchCount == 0}
    var urls : [String] = [] {
        didSet {
            if canPrefetchMoreItems, let saveResult = imagesListDidChange {
                saveResult(self)
            }
        }
    }
    
    init(networkService: NetworkService = AppDelegate.shared.context.networkService,
         fileManagerService: FileManagerService = AppDelegate.shared.context.fileManagerService) {
        self.networkService = networkService
        self.fileManagerService = fileManagerService
        loadImagesUrls()
    }
    
    private func loadImagesUrls() {
        networkService.getRandomCatImages(imgCount: 18) { [weak self] (imagesList) in
            guard let self = self else { fatalError() }
            imagesList.forEach { imageUrl in
                self.networkService.downloadImage(atUrl: imageUrl, onSuccess:  { (image, data) in
                    self.fileManagerService.saveImage(data, at: imageUrl, onSuccess: {
                        self.urls.append(imageUrl)
                    })
                }, onFailure: {
                    // TODO: - Complition for failure
                })
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
