//
//  FullScreenViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 07.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol FullScreenViewModel {
    /// Total amount of loaded images that stored in viewModel
    var itemsCount : Int { get }
    /// Call clousure if amount of images in model has chaged
    var imagesListDidChange : ((FullScreenViewModel) -> Void)? {get set}
    /// Return title for fullScreen NavigationController
    var navigationItemTitle : String { get }
    /// Load new imaged from service and notify
    func showNewImages()
    /// Return fetched image from disk for specific index
    func getImage(for index : Int, onSuccess: @escaping (UIImage?) -> Void)
    /// Save image link on disk
    func saveImage(at index : Int)
    /// Delete all images from disk exclude saved values
    func removeAllImages()
    /// Check if user have already saved image to disk
    func isSavedImage(for index : Int) -> Bool
    /// Check if user have already liked given image
    func isLikedImage(for index : Int) -> Bool
    /// Save liked images url and send data to server
    func likeImage(at index : Int)
}

final class FullScreenViewModelImplementation : FullScreenViewModel {
    private let batchAmount = 5
    private let networkService : NetworkService
    private let userDefaultsService : UserDefaultService
    private let fileManagerService : FileManagerService
    private let category : Category?
    private var savedImages : [Image] = []
    private var likedImages : [Image] = []
    private var images : [Image] = [] {
        didSet {
            if images.count > 0, images.count % batchAmount == 0, let callbackAction = imagesListDidChange {
                isLoading = false
                callbackAction(self)
            }
        }
    }
    private var isLoading = false
    
    var itemsCount : Int { images.count }
    var imagesListDidChange : ((FullScreenViewModel) -> Void)?
    var navigationItemTitle : String { return category?.name.capitalizedFirst ?? Strings.similarCats }
    
    init(_ image : Image? = nil,
         _ category : Category? = nil,
         networkService : NetworkService = AppDelegate.shared.context.networkService,
         fileManagerService : FileManagerService = AppDelegate.shared.context.fileManagerService,
         userDefaultsService : UserDefaultService = AppDelegate.shared.context.userDefaultService) {
        self.category = category
        if let originUrl = image {
            self.images.append(originUrl)
        }
        self.networkService = networkService
        self.fileManagerService = fileManagerService
        self.userDefaultsService = userDefaultsService
        savedList()
    }
    
    private func savedList () {
        if let userImages = userDefaultsService.getUserImages() {
            savedImages = userImages.savedImages
            likedImages = userImages.likedImages
        }
    }
    
    private func loadImages() {
        isLoading = true
        networkService.getRandomCatImages(category : category?.id, imgCount: batchAmount, onSuccess:  { [weak self] (imagesList) in
            guard let self = self else { return }
            imagesList.forEach { (imageModel) in
                self.networkService.downloadImage(atUrl: imageModel.imageUrl, onSuccess:  { [weak self] (image, data) in
                    guard let self = self else { fatalError() }
                    self.fileManagerService.saveImage(data, at: imageModel.imageUrl, onSuccess: { [weak self] in
                        guard let self = self else { fatalError() }
                        self.images.append(imageModel)
                    })
                }, onFailure: {
                    // TODO: - Complition for failure
                })
            }
        }, onFailure: {
        })
    }
    
    func getImage(for index : Int, onSuccess: @escaping (UIImage?) -> Void) {
        if index < images.count {
            fileManagerService.fetchImage(at: images[index].imageUrl, onSuccess:  { (image) in
                onSuccess(image)
            })
        }
    }
    
    func showNewImages() {
        if !isLoading {
            loadImages()
        }
    }
    
    func removeAllImages() {
        images.remove(at: 0)
        fileManagerService.deleteAllItems(at: images.filter({ !savedImages.contains($0) }))
        images.removeAll()
    }
    
    // MARK: - Save and Like actions
    func saveImage(at index : Int) {
        if let firstIndex = savedImages.firstIndex(of: images[index]) {
            savedImages.remove(at: firstIndex)
        } else {
            savedImages.append(images[index])
        }
        userDefaultsService.updateSavedList(images[index])
    }
    
    func isSavedImage(for index : Int) -> Bool {
        return savedImages.contains(images[index])
    }
    
    func likeImage(at index : Int) {
        let vote : Int
        if let firstIndex = likedImages.firstIndex(of: images[index]) {
            likedImages.remove(at: firstIndex)
            vote = 0
        } else {
            likedImages.append(images[index])
            vote = 1
        }
        networkService.postLike(vote, images[index].imageID)
        userDefaultsService.updateLikedImages(images[index])
    }
    
    func isLikedImage(for index : Int) -> Bool {
        return likedImages.contains(images[index])
    }
}
