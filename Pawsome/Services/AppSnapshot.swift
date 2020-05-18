//
//  AppSnapshot.swift
//  Pawsome
//
//  Created by Marentilo on 18.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

final class AppSnapshot {
    /// Call remove action to remove data from disk before user close the app
    static func removeImagesFromDisk(fileManagerService : FileManagerService = AppDelegate.shared.context.fileManagerService,
                                     userDefaultsService : UserDefaultService = AppDelegate.shared.context.userDefaultService) {
        if let images = userDefaultsService.getUnusedImages() {
            fileManagerService.deleteAllItems(at: images)
        }
    }
}

