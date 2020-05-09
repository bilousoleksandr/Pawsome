//
//  FileManagerService.swift
//  Pawsome
//
//  Created by Marentilo on 07.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol FileManagerServiceHolder {
    var fileManagerService : FileManagerService { get }
}

protocol FileManagerService {
    /// Save image data with given url on background queue
    func saveImage(_ data: Data, at path : String, onSuccess: @escaping () -> Void)
    
    /// Fetch data for given URL in background queue and return result on main thread
    func fetchImage(at path : String, onSuccess: @escaping (UIImage?) -> Void)
    
    /// Delete all given data from disk
    func deleteAllItems(at Urls: [String])
}

final class FileManagerServiceImplementation : FileManagerService {
    private let fileManager = FileManager.default

    private func getStandartURL () -> URL {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError()
        }
        return url
    }
    
    private func urlForImage(_ imageName : String) -> URL {
        let newFileName = imageName.replacingOccurrences(of: "/", with: "")
        return getStandartURL().appendingPathComponent(newFileName)
    }
    
    func saveImage(_ data: Data, at path : String, onSuccess: @escaping () -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { fatalError() }
            do {
                try data.write(to: self.urlForImage(path))
                DispatchQueue.main.async {
                    onSuccess()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchImage(at path : String, onSuccess: @escaping (UIImage?) -> Void) {
        let imagePath = urlForImage(path)
        if fileManager.fileExists(atPath: imagePath.path) {
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: imagePath) else { return }
                DispatchQueue.main.async {
                    onSuccess(UIImage(data: data))
                }
            }
        }
    }
    
    func deleteAllItems(at urls: [String]) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { fatalError() }
            urls.forEach {
                let imagePath = self.urlForImage($0)
                do {
                    try self.fileManager.removeItem(atPath: imagePath.path)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
