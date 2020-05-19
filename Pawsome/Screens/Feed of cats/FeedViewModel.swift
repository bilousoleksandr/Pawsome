//
//  FeedViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 04.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol FeedViewModel : class {
    /// Call clousure if imagesList has changed
    var imagesListDidChange : ((FeedViewModel) -> ())? {get set}
    /// Callback action which called after categories list did update
    var categoriesListDidChange : ((FeedViewModel) -> ())? { get set }
    /// Callback for loading error from server
    var listDidFailLoading : (() -> ())? {get set}
    /// Check if previous fetch is canceled before send one more request
    var canPrefetchMoreItems : Bool { get }
    /// Actual array of image categories
    var imageCategories : [String] { get }
    /// Total amount of loaded images to feed
    var imagesCount : Int { get }
    /// Tell viewModel to upload more images and display them in feed
    func showNewImages()
    /// Get cached images
    func getImage(for index: Int, complition: @escaping (UIImage?) -> Void)
    /// Delete all images from canvas and refresh urls list
    func imageForPressedItem(at index : Int) -> Image
    /// Call action to save image URLS before view will dismiss
    func saveImagesOnDisk()
    /// Load actual categories from server
    func loadCategories()
    /// Return category model according to given name
    func selectedCategory(name : String) -> Category
}

class FeedViewModelImplementation : FeedViewModel {
    private let batchCount = 18
    private let networkService : NetworkService
    private let fileManagerService : FileManagerService
    private let userDefaultsService : UserDefaultService
    var imagesListDidChange : ((FeedViewModel) -> ())?
    var listDidFailLoading : (() -> ())?
    var categoriesListDidChange : ((FeedViewModel) -> ())? {
        didSet {
            loadCategories()
        }
    }
    var canPrefetchMoreItems : Bool {
        return images.count > 0 && images.count % batchCount == 0
    }
    var imagesCount : Int { images.count }
    var images : [Image] = [] {
        didSet {
            if canPrefetchMoreItems, let saveResult = imagesListDidChange {
                saveResult(self)
            }
        }
    }
    
    private var categories : [Category]? {
        didSet {
            if let updateView = categoriesListDidChange {
                updateView(self)
            }
        }
    }
    
    var imageCategories : [String] {
        (categories ?? []).map({ $0.name.capitalizedFirst })
    }
    
    init(networkService: NetworkService = AppDelegate.shared.context.networkService,
         fileManagerService: FileManagerService = AppDelegate.shared.context.fileManagerService,
         userDefaultsService : UserDefaultService = AppDelegate.shared.context.userDefaultService) {
        self.networkService = networkService
        self.fileManagerService = fileManagerService
        self.userDefaultsService = userDefaultsService
        loadImagesUrls()
    }
    
    private func loadImagesUrls() {
        networkService.getRandomCatImages(category: nil, imgCount: batchCount, onSuccess: { [weak self] (imagesList) in
            guard let self = self else { fatalError() }
            imagesList.forEach { imageModel in
                self.networkService.downloadImage(atUrl: imageModel.imageUrl, onSuccess:  { (image, data) in
                    self.fileManagerService.saveImage(data, at: imageModel.imageUrl, onSuccess: {
                        self.images.append(imageModel)
                    })
                }, onFailure: {
                    print("Error occured")
                })
            }
        }, onFailure: { [weak self] in
            if let callback = self?.listDidFailLoading {
                callback()
            }
        })
    }
    
    func loadCategories() {
        networkService.fetchImageCategories(onSuccess: { [weak self] (loadedCategories) in
            self?.categories = loadedCategories
        }, onFailure: {
            print("Error during category download")
        })
    }
    
    func getImage(for index: Int, complition: @escaping (UIImage?) -> Void) {
        fileManagerService.fetchImage(at: images[index].imageUrl, onSuccess:  { (image) in
            complition(image)
        })
    }
    
    func showNewImages() {
        loadImagesUrls()
    }
    
    func imageForPressedItem(at index: Int) -> Image {
        return images[index]
    }
    
    func selectedCategory(name : String) -> Category {
        if let allCategories = categories, let category = allCategories.filter({ $0.name == name.lowercased() }).first {
            return category
        }
        return Category(id: 1, name: "nil")
    }
    
    func saveImagesOnDisk() {
        userDefaultsService.saveFeedImages(images)
    }
}
