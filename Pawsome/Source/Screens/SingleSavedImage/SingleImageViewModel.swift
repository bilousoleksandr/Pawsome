//
//  SingleImageViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 16.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol SingleImageViewModel {
    /// Check if current image is liked
    var isLiked : Bool { get }
    /// Check if current image is saved
    var isSaved : Bool { get}
    /// Load image from disk at specific URL and return it via clousure
    func fechImage(complition: @escaping (UIImage?) -> Void)
    /// Save presented image to disk
    func saveImage()
    /// Post vote to server and save image url to disk
    func likeImage(isSelected : Bool)
}

struct SingleImageViewModelImplementation : SingleImageViewModel {
    private let image : Image
    private let fileManagerService : FileManagerService
    private let userDefaultsService : UserDefaultService
    private let networkService : NetworkService
    var isLiked: Bool { userDefaultsService.getUserImages()?.likedImages.contains(image) ?? false }
    var isSaved: Bool { userDefaultsService.getUserImages()?.savedImages.contains(image) ?? false }
    
    init(image : Image,
         fileManagerService : FileManagerService = AppDelegate.shared.context.fileManagerService,
         userDefaultsService : UserDefaultService = AppDelegate.shared.context.userDefaultService,
         networkService : NetworkService = AppDelegate.shared.context.networkService) {
        self.image = image
        self.fileManagerService = fileManagerService
        self.userDefaultsService = userDefaultsService
        self.networkService = networkService
    }
    
    func fechImage(complition: @escaping (UIImage?) -> Void) {
        fileManagerService.fetchImage(at: image.imageUrl, onSuccess: { (image) in
            complition(image)
        })
    }
    
    func saveImage() {
        userDefaultsService.updateSavedList(image)
    }
    
    func likeImage(isSelected : Bool) {
        userDefaultsService.updateLikedImages(image)
        networkService.postLike(isSelected ? 1 : 0, image.imageID)
    }
}
