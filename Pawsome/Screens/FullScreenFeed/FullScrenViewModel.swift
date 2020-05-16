//
//  FullScrenViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 07.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol FullScrenViewModelProtocol {
    /// Total amount of loaded images that stored in viewModel
    var itemsCount : Int { get }
    /// Call clousure if amount of images in model has chaged
    var imagesListDidChange : ((FullScrenViewModelProtocol) -> Void)? {get set}
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

final class FullScrenViewModel : FullScrenViewModelProtocol {
    private let batchAmount = 5
    private let networkService : NetworkService
    private let userDefaultsService : UserDefaultService
    private let fileManagerService : FileManagerService
    private var savedUrls : [String] = []
    private var likedUrls : [String] = []
    private var urls : [String] = [] {
        didSet {
            if urls.count > 0, urls.count % batchAmount == 0, let callbackAction = imagesListDidChange {
                callbackAction(self)
            }
        }
    }
    
    var itemsCount : Int { urls.count }
    var imagesListDidChange : ((FullScrenViewModelProtocol) -> Void)?
    
    init(_ imageURL : String,
         networkService : NetworkService = AppDelegate.shared.context.networkService,
         fileManagerService : FileManagerService = AppDelegate.shared.context.fileManagerService,
         userDefaultsService : UserDefaultService = AppDelegate.shared.context.userDefaultService) {
        self.urls.append(imageURL)
        self.networkService = networkService
        self.fileManagerService = fileManagerService
        self.userDefaultsService = userDefaultsService
        savedList()
    }
    
    private func savedList () {
        if let userImages = userDefaultsService.getUserImages() {
            savedUrls = userImages.savedImages
            likedUrls = userImages.likedImages
        }
    }
    
    private func loadImages() {
        networkService.getRandomCatImages(imgCount: batchAmount) { [weak self] (imagesUrls) in
            guard let self = self else { return }
            imagesUrls.forEach { (url) in
                self.networkService.downloadImage(atUrl: url, onSuccess:  { [weak self] (image, data) in
                    guard let self = self else { fatalError() }
                    self.fileManagerService.saveImage(data, at: url, onSuccess: { [weak self] in
                        guard let self = self else { fatalError() }
                        self.urls.append(url)
                    })
                }, onFailure: {
                    print("fail")
                })
            }
        }
    }
    
    func getImage(for index : Int, onSuccess: @escaping (UIImage?) -> Void) {
        if index < urls.count {
            fileManagerService.fetchImage(at: urls[index]) { (image) in
                onSuccess(image)
            }
        }
    }
    
    func showNewImages() {
        loadImages()
    }
    
    func removeAllImages() {
        urls.remove(at: 0)
        fileManagerService.deleteAllItems(at: urls.filter({ !savedUrls.contains($0) }))
        urls.removeAll()
    }
    
    // MARK: - Save and Like actions
    func saveImage(at index : Int) {
        if let firstIndex = savedUrls.firstIndex(of: urls[index]) {
            savedUrls.remove(at: firstIndex)
        } else {
            savedUrls.append(urls[index])
        }
        userDefaultsService.updateSavedList(urls[index])
    }
    
    func isSavedImage(for index : Int) -> Bool {
        return savedUrls.contains(urls[index])
    }
    
    func likeImage(at index : Int) {
        let vote : Int
        if let firstIndex = likedUrls.firstIndex(of: urls[index]) {
            likedUrls.remove(at: firstIndex)
            vote = 0
        } else {
            likedUrls.append(urls[index])
            vote = 1
        }
        networkService.postLike(vote, "id")
        userDefaultsService.updateLikedImages(urls[index])
    }
    
    func isLikedImage(for index : Int) -> Bool {
        return likedUrls.contains(urls[index])
    }
}
