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
    let dogFriendly, strangerFriendly, energyLevel, experimental, socialNeeds, adaptability, intelligence, childFriendly : Int
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
        case experimental, adaptability, intelligence, weight, temperament, origin
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
    var averageLifeSpan : String { get }
    var averageWeight : String { get }
    var breedName : String { get }
    var breedDescription : String { get }
    var origin : String { get }
    var temperament : [String] { get }
    var breedFeatures : [BreedFeature] {get}
    var intelligence : String { get}
    var socialNeeds : String {get}
        
    /// Get breed temperament for current index
    func temperament(for index: Int) -> String
}

class BreedViewModel : BreedViewModelProtocol {
    private let breed : Breed
    var averageLifeSpan: String { breed.lifeSpan.replacingOccurrences(of: " ", with: "") }
    var averageWeight: String { breed.weight.metricWeight.replacingOccurrences(of: " ", with: "") }
    var breedName: String { breed.breedName }
    var breedDescription: String { breed.breedDescription }
    var origin: String { breed.origin}
    var strangerFriendly : String { "\(breed.strangerFriendly)/5" }
    var intelligence : String { "\(breed.intelligence)/5" }
    var socialNeeds : String { "\(breed.socialNeeds)/5" }
    
    var temperament: [String] {
        return breed.temperament.split(separator: ",").map({ String($0).replacingOccurrences(of: " ", with: "")})
    }
    
    var breedFeatures : [BreedFeature] {
        var features : [BreedFeature] = []
        features.append(BreedFeature(featureName: Strings.strangerFriendly, index: breed.strangerFriendly, commonImage: #imageLiteral(resourceName: "strangerFriendlyCommon"), highlightedImage: #imageLiteral(resourceName: "strangerFriendly")))
        features.append(BreedFeature(featureName: Strings.socialNeeds, index: breed.socialNeeds, commonImage: #imageLiteral(resourceName: "socialNeedsCommon"), highlightedImage: #imageLiteral(resourceName: "socialNeeds")))
        features.append(BreedFeature(featureName: Strings.intelligence, index: breed.intelligence, commonImage: #imageLiteral(resourceName: "brainCommon"), highlightedImage: #imageLiteral(resourceName: "brain")))
        features.append(BreedFeature(featureName: Strings.energyLevel, index: breed.energyLevel, commonImage: #imageLiteral(resourceName: "energyCommon"), highlightedImage: #imageLiteral(resourceName: "energy")))
        features.append(BreedFeature(featureName: Strings.dogFriendly, index: breed.dogFriendly, commonImage: #imageLiteral(resourceName: "dogFriendlyCommon"), highlightedImage: #imageLiteral(resourceName: "dogFriendly")))
        features.append(BreedFeature(featureName: Strings.childFriendly, index: breed.childFriendly, commonImage: #imageLiteral(resourceName: "childCommon"), highlightedImage: #imageLiteral(resourceName: "child")))
        features.append(BreedFeature(featureName: Strings.adaptability, index: breed.adaptability, commonImage: #imageLiteral(resourceName: "adaptabilityCommon"), highlightedImage: #imageLiteral(resourceName: "adaptability")))
        print(breed.experimental)
        return features
    }
    
    init (breed: Breed) {
        self.breed = breed
    }
    
    func temperament(for index: Int) -> String {
        return temperament[index]
    }
}
