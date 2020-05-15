//
//  SavedImagesViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol SavedImagesViewModelProtocol {
    /// Count of saved imaged on disk
    var imagesCount : Int { get }
    /// Notify view if images URL count is updated
    var urlsArrayDidUpdate : ((SavedImagesViewModelProtocol) -> Void)? { get set }
    /// Load image from disk and return value if it exist
    func imageForItem(at index : Int, onSuccess: @escaping (UIImage?) -> Void)
}

final class SavedImagesViewModel : SavedImagesViewModelProtocol {
    private let userDefaultsService : UserDefaultService
    private let fileManagerService : FileManagerService
    var urlsArrayDidUpdate : ((SavedImagesViewModelProtocol) -> Void)?
    private var imageUrls : [String] = [] {
        didSet {
            if let action = urlsArrayDidUpdate {
                action(self)
            }
        }
    }
    
    var imagesCount: Int {
        loadImages()
        return imageUrls.count
    }
    
    init(userDefaultsService : UserDefaultService = AppDelegate.shared.context.userDefaultService,
         fileManagerService : FileManagerService = AppDelegate.shared.context.fileManagerService) {
        self.userDefaultsService = userDefaultsService
        self.fileManagerService = fileManagerService
    }
     
    private func loadImages() {
        if let savedImagesModel = userDefaultsService.getUserImages() {
            imageUrls = savedImagesModel.savedImages
        }
    }
    
    func imageForItem(at index : Int, onSuccess: @escaping (UIImage?) -> Void) {
        fileManagerService.fetchImage(at: imageUrls[index]) { (image) in
            onSuccess(image)
        }
    }
}
