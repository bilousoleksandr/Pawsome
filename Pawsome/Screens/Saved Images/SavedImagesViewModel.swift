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

protocol SavedImagesViewModelProtocol {
    /// Count of saved imaged on disk
    var savedImagesCount : Int { get }
    /// Count of liked images, that stored on disk
    var likedImagesCount : Int { get }
    /// Notify view if images URL count is updated
    var urlsArrayDidUpdate : ((SavedImagesViewModelProtocol) -> Void)? { get set }
    /// Load image from disk and return value if it exist
    func savedImageForItem(at index : Int, for list : ImagesList, onSuccess: @escaping (UIImage?) -> Void)
    ///URL for item at specific path
    func urlForItem(at index : Int, for list : ImagesList) -> String
}

final class SavedImagesViewModel : SavedImagesViewModelProtocol {
    private let userDefaultsService : UserDefaultService
    private let fileManagerService : FileManagerService
    var urlsArrayDidUpdate : ((SavedImagesViewModelProtocol) -> Void)?
    private var savedImageUrls : [String] = [] {
        didSet {
            callback()
        }
    }
    
    private var likedImageUrls : [String] = [] {
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
    
    private func sourceList(_ list : ImagesList) -> [String] {
        let source : [String]
        switch list {
        case .liked: source = likedImageUrls
        case .saved: source = savedImageUrls
        }
        return source
    }
    
    func savedImageForItem(at index : Int, for list : ImagesList, onSuccess: @escaping (UIImage?) -> Void) {
        let source = sourceList(list)
        fileManagerService.fetchImage(at: source[index]) { (image) in
            onSuccess(image)
        }
    }
    
    func urlForItem(at index : Int, for list : ImagesList) -> String {
        let source = sourceList(list)
        return source[index]
    }
}
