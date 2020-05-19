//
//  BreedViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 04.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

// MARK: - BreedFeature
struct BreedFeature {
    let featureName : String
    let index : Int
    let commonImage : UIImage
    let highlightedImage : UIImage
}

// MARK: - Breed
struct Breed : Codable {
    let breedName, lifeSpan, breedDescription, temperament, origin : String
    let dogFriendly, strangerFriendly, energyLevel, socialNeeds, adaptability, intelligence : Int
    let childFriendly, natural, rare, experimental : Int
    let weight : Weight
    
    enum CodingKeys : String, CodingKey {
        case breedName              = "name"
        case breedDescription       = "description"
        case lifeSpan               = "life_span"
        case dogFriendly            = "dog_friendly"
        case strangerFriendly       = "stranger_friendly"
        case energyLevel            = "energy_level"
        case socialNeeds            = "social_needs"
        case childFriendly          = "child_friendly"
        case origin                 = "country_code"
        case adaptability, intelligence, weight, temperament, natural, rare, experimental
    }
}

// MARK: - Category

struct Category : Codable {
    let id : Int
    let name : String
    
    enum CodingKeys : String, CodingKey {
        case id, name
    }
}

// MARK: - Weight
struct Weight : Codable {
    let metricWeight : String
    
    enum CodingKeys : String, CodingKey {
        case metricWeight = "metric"
    }
}

// MARK: - BreedViewModelProtocol
protocol BreedViewModelProtocol : class  {
    /// Callback for successfull data fetching and serialization
    var breedsDidLoad : (() -> Void)? { get set }
    /// Call clousure if loading did failed or something go wrong during data serialization
    var breeadsFailedLoad : (() -> Void)? { get set }
    /// Total amount of loaded breeds
    var breedsCount : Int { get }
    /// Send request to server and get actual breeds list
    func fetchBreedsList()
    /// Return breed name and origin for given index
    func breedDetails(for index : Int) -> (name : String, origin : String)
    /// Return breed for given index
    func singleBreed(for index : Int) -> Breed
}

class BreedViewModel : BreedViewModelProtocol {
    private let networkService : NetworkService
    private var breeds : [Breed] = []
    var breedsDidLoad : (() -> Void)?
    var breeadsFailedLoad : (() -> Void)?
    var breedsCount : Int { breeds.count }
    
    init (networkService : NetworkService = AppDelegate.shared.context.networkService) {
        self.networkService = networkService
    }
    
    func fetchBreedsList() {
        networkService.fetchAllBreeds(onSuccess: { [weak self] (breeds) in
            self?.breeds = breeds
            if let callbackAction = self?.breedsDidLoad {
                callbackAction()
            }
        }, onFailure: { [weak self] in
            if let callbackAction = self?.breeadsFailedLoad {
                callbackAction()
            }
        })
    }
    
    func breedDetails(for index : Int) -> (name : String, origin : String) {
        let sourceBreed = breeds[index]
        return (name: sourceBreed.breedName, origin: sourceBreed.origin)
    }
    
    func singleBreed(for index : Int) -> Breed {
        breeds[index]
    }
}
