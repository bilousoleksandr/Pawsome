//
//  SavedImagesViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

enum ImagesList : Int {
    case liked = 0
    case saved
}

protocol SavedImagesViewModel {
    /// Count of saved imaged on disk
    var savedImagesCount : Int { get }
    /// Count of liked images, that stored on disk
    var likedImagesCount : Int { get }
    /// Notify view if images URL count is updated
    var urlsArrayDidUpdate : ((SavedImagesViewModel) -> Void)? { get set }
    /// Check if imageSource is empry and return special image of nil if some values exist
    func imageForEmptySource(_ imageList : ImagesList) -> UIImage?
    /// Load image from disk and return value if it exist
    func savedImageForItem(at index : Int, for list : ImagesList, onSuccess: @escaping (UIImage?) -> Void)
    /// Show full screen saved image
    func presentFullScreenImage(at index : Int, for list : ImagesList)
}

final class SavedImagesViewModelImplementation : SavedImagesViewModel {
    private let userDefaultsService : UserDefaultService
    private let fileManagerService : FileManagerService
    weak var coordinator : SavedImagesCoordinator?
    var urlsArrayDidUpdate : ((SavedImagesViewModel) -> Void)?
    private var savedImageUrls : [Image] = [] {
        didSet {
            callback()
        }
    }
    
    private var likedImageUrls : [Image] = [] {
        didSet {
            callback()
        }
    }
    
    var likedImagesCount : Int {
        loadImages()
        return likedImageUrls.count
    }
    
    var savedImagesCount: Int {
        loadImages()
        return savedImageUrls.count
    }
    
    init(userDefaultsService : UserDefaultService = AppDelegate.shared.context.userDefaultService,
         fileManagerService : FileManagerService = AppDelegate.shared.context.fileManagerService) {
        self.userDefaultsService = userDefaultsService
        self.fileManagerService = fileManagerService
    }
     
    private func loadImages() {
        if let savedImagesModel = userDefaultsService.getUserImages() {
            savedImageUrls = savedImagesModel.savedImages
            likedImageUrls = savedImagesModel.likedImages
        }
    }
    
    private func callback () {
        if let action = urlsArrayDidUpdate {
            action(self)
        }
    }
    
    private func sourceList(_ list : ImagesList) -> [Image] {
        let source : [Image]
        switch list {
        case .liked: source = likedImageUrls
        case .saved: source = savedImageUrls
        }
        return source
    }
    
    func savedImageForItem(at index : Int, for list : ImagesList, onSuccess: @escaping (UIImage?) -> Void) {
        let source = sourceList(list)
        fileManagerService.fetchImage(at: source[index].imageUrl, onSuccess: { (image) in
            onSuccess(image)
        })
    }
    
    private func imageForItem(at index : Int, for list : ImagesList) -> Image {
        let source = sourceList(list)
        return source[index]
    }
    
    func imageForEmptySource(_ imageList : ImagesList) -> UIImage? {
        loadImages()
        if !sourceList(imageList).isEmpty {
            return nil
        }
        return imageList == .liked ? #imageLiteral(resourceName: "noLikedImages") : #imageLiteral(resourceName: "noSavedImages")
    }
    
    func presentFullScreenImage(at index : Int, for list : ImagesList) {
        let image = imageForItem(at: index, for: list)
        coordinator?.showFullScreenImage(image: image)
    }
}
