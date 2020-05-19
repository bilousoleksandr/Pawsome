//
//  UserDefaultService.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

// MARK: - SettingsModel
struct UserImagesModel : Codable {
    var savedImages : [Image]
    var likedImages : [Image]
    
    enum CodingKeys : String, CodingKey {
        case savedImages, likedImages
    }
}

// MARK: - AllFeedImages
struct AllFeedImages : Codable {
    var allImages : [Image]
}

protocol UserDefaultServiceHolder {
    var userDefaultService : UserDefaultService { get }
}

protocol UserDefaultService {
    /// Add url to list or remove it if already exist
    func updateSavedList (_ savedImage : Image)
    /// Return model with all saved amd liked images url
    func getUserImages () -> UserImagesModel?
    /// Add likedImage to list or remove it if already exist
    func updateLikedImages (_ savedImage : Image)
    /// Save all feed images links
    func saveFeedImages(_ imageURLS : [Image])
    /// Return all images except liked and saved values
    func getUnusedImages() -> [Image]?
}

final class UserDefaultServiceImpementation : UserDefaultService {
    private let userDefaults : UserDefaults
    
    init(userDefaults : UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func getUserImages () -> UserImagesModel? {
        if let data = userDefaults.value(forKey: Constants.storedImagesKey) as? Data,
            let savedImages = Serializer.deserialize(from: data, value: UserImagesModel.self){
                return savedImages
        }
        return nil
    }
    
    func updateSavedList (_ savedImage : Image) {
        var newValue : UserImagesModel
        if let savedImages = getUserImages() {
            newValue = savedImages
            if let firstIndex = newValue.savedImages.firstIndex(of: savedImage) {
                newValue.savedImages.remove(at: firstIndex)
            } else {
                newValue.savedImages.append(savedImage)
            }
        } else {
            newValue = UserImagesModel(savedImages: [savedImage], likedImages: [Image]())
        }
        saveUpdatedValue(newValue)
    }
    
    private func saveUpdatedValue(_ imageList : UserImagesModel) {
        if let encodeValue = Serializer.serialize(value: imageList) {
            userDefaults.set(encodeValue, forKey: Constants.storedImagesKey)
        }
    }
    
    func updateLikedImages (_ savedImage : Image) {
        var newValue : UserImagesModel
        if let savedImages = getUserImages() {
            newValue = savedImages
            if let firstIndex = newValue.likedImages.firstIndex(of: savedImage) {
                newValue.likedImages.remove(at: firstIndex)
            } else {
                newValue.likedImages.append(savedImage)
            }
        } else {
            newValue = UserImagesModel(savedImages: [Image](), likedImages: [savedImage])
        }
        saveUpdatedValue(newValue)
    }
    
    func saveFeedImages(_ imageURLS : [Image]) {
        let allImages = AllFeedImages(allImages: imageURLS)
        if let data = Serializer.serialize(value: allImages) {
            userDefaults.set(data, forKey: Constants.feedImagesKey)
        }
    }
    
    func getUnusedImages() -> [Image]? {
        if let data = userDefaults.value(forKey: Constants.feedImagesKey) as? Data,
            let feedModel = Serializer.deserialize(from: data, value: AllFeedImages.self),
            let userImages = getUserImages() {
            return feedModel.allImages.filter({ !userImages.likedImages.contains($0) && !userImages.savedImages.contains($0) })
        }
        return nil
    }
}

// MARK: - Constants -
private extension UserDefaultServiceImpementation {
    enum Constants {
        static let storedImagesKey = "storedImagesKey"
        static let feedImagesKey = "feedImagesKey"
    }
}
