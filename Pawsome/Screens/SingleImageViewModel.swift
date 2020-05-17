//
//  SingleImageViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 16.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol SingleImageViewModelProtocol {
    /// Load image from disk at specific URL and return it via clousure
    func fechImage(complition: @escaping (UIImage?) -> Void)
}

struct SingleImageViewModel : SingleImageViewModelProtocol {
    private let imageUrl : String
    private let fileManagerService : FileManagerService
    
    init(imageUrl : String, fileManagerService : FileManagerService = AppDelegate.shared.context.fileManagerService) {
        self.imageUrl = imageUrl
        self.fileManagerService = fileManagerService
    }
    
    func fechImage(complition: @escaping (UIImage?) -> Void) {
        fileManagerService.fetchImage(at: imageUrl) { (image) in
            complition(image)
        }
    }
}
