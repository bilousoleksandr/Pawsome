//
//  NetworkService.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

// MARK: - POSTRequestModel
struct PostRequest : Codable {
    let imageID : String
    let userID : String
    let likeValue : Int
    
    enum CodingKeys : String, CodingKey {
        case imageID = "image_id"
        case userID = "sub_id"
        case likeValue = "value"
    }
}

protocol NetworkServiceHolder {
    var networkService : NetworkService { get }
}

protocol NetworkService {
    /// Dowload list of breeds and its description from server
    func fetchAllBreeds(onSuccess : @escaping ([Breed]) -> (), onFailure : @escaping () -> Void)
    
    /// Return array of image urls from server with given amount of elements
    func getRandomCatImages(imgCount : Int, onSuccess: @escaping ([String]) -> ())
    
    /// Load data from given url and return UIImage and Data via callback clousure
    func downloadImage(atUrl url: String, onSuccess: @escaping (UIImage?, Data) -> (), onFailure : @escaping () -> Void)
    
    /// Post users like to server with unique UUID
    func postLike(_ value : Int, _ imageID : String)
}

final class NetworkServiceImplementation : NetworkService {
    
    private let urlSession : URLSession
    
    init (urlSession : URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func fetchAllBreeds(onSuccess : @escaping ([Breed]) -> (), onFailure : @escaping () -> Void) {
        let dataTask = urlSession.dataTask(with: makeRequest(with: Constants.breedsUrl)) { (data, response, error) in
            guard let allData = data, error == nil else {
                onFailure()
                return
            }
            do {
                let breeds = try JSONDecoder().decode([Breed].self, from: allData)
                DispatchQueue.main.async {
                    onSuccess(breeds)
                }
            } catch {
                onFailure()
            }
        }
        dataTask.resume()
    }
    
    func getRandomCatImages(imgCount : Int, onSuccess: @escaping ([String]) -> ()) {
        let urlName = "images/search?limit=\(imgCount)&order=\(ImagesOrder.random)&size=small"
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
    
    func downloadImage(atUrl url: String, onSuccess: @escaping (UIImage?, Data) -> (), onFailure : @escaping () -> Void) {
        guard let imageUrl = URL(string: url) else { return }
        let dataTask = urlSession.dataTask(with: imageUrl, completionHandler: { (data, response, error) in
            guard let data = data, error == nil else {
                onFailure()
                return
            }
            DispatchQueue.main.async {
                onSuccess(UIImage(data: data), data)
            }
        })
        dataTask.resume()
    }
    
    func postLike(_ value : Int, _ imageID : String) {
        do {
            let postData = try JSONEncoder().encode(PostRequest(imageID: "MTg1NjkxNQ",
                                                                userID: UIDevice.uniqID(),
                                                                likeValue: value))
            let request = makeRequest(with: Constants.likes,
                                      httpMethod: HTTPMethods.post,
                                      data: postData,
                                      header: Constants.postHeader)
            let task = urlSession.dataTask(with: request) { (_, response, error) in
                guard error == nil else { return }
            }
            task.resume()
        } catch {
            
        }
    }
}

private extension NetworkServiceImplementation {
    func makeRequest(with url: String,
                     httpMethod : String = HTTPMethods.get,
                     data : Data? = nil,
                     header : [String : String] = Constants.getHeader) -> URLRequest {
        guard let url = URL(string: "\(Constants.host)\(url)") else {
            fatalError()
        }
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = httpMethod
        request.allHTTPHeaderFields = header
        if let postedData = data {
            request.httpBody = postedData
        }
        return request as URLRequest
    }
    
    enum Constants {
        static let getHeader = ["x-api-key": "b8148468-b823-4b33-b6ca-4a6c994d0635"]
        static let postHeader = ["x-api-key": "b8148468-b823-4b33-b6ca-4a6c994d0635", "content-type": "application/json"]
        static let host = "https://api.thecatapi.com/v1/"
        static let breedsUrl = "breeds"
        static let likes = "votes"
    }
    
    enum ImagesOrder {
        static let random = "RAND"
        static let ascending = "ASC"
        static let descending = "DESC"
    }
    
    enum HTTPMethods {
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

