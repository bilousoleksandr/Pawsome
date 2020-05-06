//
//  NetworkService.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol NetworkServiceHolder {
    var networkService : NetworkService { get }
}

protocol NetworkService {
    /// download all breeds description
//    func allBreeds()
    func getRandomCatImages(onSuccess: @escaping ([String]) -> ())
    
    func downloadImage(atUrl url: String, onSuccess: @escaping (UIImage?) -> ())
}

final class NetworkServiceImplementation : NetworkService {
    private let urlSession : URLSession
    
    init (urlSession : URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func allBreeds(onSuccess: @escaping ([Breed]) -> ()) {
        let dataTask = urlSession.dataTask(with: makeRequest(with: Constants.breedsUrl)) { (data, response, error) in
            guard let allData = data, error == nil else {
                fatalError()
            }
            do {
                let breeds = try JSONDecoder().decode([Breed].self, from: allData)
                onSuccess(breeds)
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    func getRandomCatImages(onSuccess: @escaping ([String]) -> ()) {
        let urlName = "images/search?limit=15&order=RAND&size=thumb"
        let dataTask = urlSession.dataTask(with: makeRequest(with: urlName)) { (data, response, error) in
            guard let allData = data, error == nil else {
                return
            }
            do {
                let images = try JSONDecoder().decode([Image].self, from: allData)
                DispatchQueue.main.async {
                    onSuccess(images.map({ $0.imageUrl}))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        dataTask.resume()
    }
    
    func downloadImage(atUrl url: String, onSuccess: @escaping (UIImage?) -> ()) {
        guard let imageUrl = URL(string: url) else {
            fatalError()
        }
        let dataTask = urlSession.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                onSuccess(UIImage(data: data))
            }
        })
        dataTask.resume()
    }
}

private extension NetworkServiceImplementation {
    private func makeRequest(with url: String) -> URLRequest {
        guard let url = URL(string: "\(Constants.host)\(url)") else {
            fatalError()
        }
        print(url.absoluteString)
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = HTTPMethods.get
        request.allHTTPHeaderFields = Constants.headers
        return request as URLRequest
    }
    
    private enum Constants {
        static let headers = ["x-api-key": "b8148468-b823-4b33-b6ca-4a6c994d0635"]
        static let host = "https://api.thecatapi.com/v1/"
        static let breedsUrl = "breeds"
    }
    
    private enum ImagesOrder {
        static let random = "RAND"
        static let ascending = "ASC"
        static let descending = "DESC"
    }
    
    private enum HTTPMethods {
        static let get = "GET"
        static let post = "POST"
    }
}

// MARK: Images
struct Image : Codable {
    let height, width : Int
    let imageID, imageUrl : String
    
    enum CodingKeys : String, CodingKey {
        case height, width
        case imageID = "id"
        case imageUrl = "url"
    }
}

