//
//  SingleBreedViewModel.swift
//  Pawsome
//
//  Created by Marentilo on 15.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

// MARK: - SingleBreedViewModelProtocol
protocol SingleBreedViewModel : class  {
    var averageLifeSpan : String { get }
    var averageWeight : String { get }
    var breedName : String { get }
    var breedDescription : String { get }
    var origin : String { get }
    var temperament : [String] { get }
    var natural : Int { get }
    var rare : Int { get }
    var experimental : Int { get }
    /// Convert breed temperament to data model with name and common | highlighted image
    var breedFeatures : [BreedFeature] {get}
    /// Transform given string of temperament to array
    func temperament(for index: Int) -> String
}

final class SingleBreeViewModelImplementation : SingleBreedViewModel {
    private let breed : Breed
    var averageLifeSpan: String { breed.lifeSpan.replacingOccurrences(of: " ", with: "") }
    var averageWeight: String { breed.weight.metricWeight.replacingOccurrences(of: " ", with: "") }
    var breedName: String { breed.breedName }
    var breedDescription: String { breed.breedDescription }
    var origin: String { breed.origin}
    var natural : Int { breed.natural }
    var rare : Int { breed.rare }
    var experimental : Int { breed.experimental }
    
    init(breed: Breed) {
        self.breed = breed
    }
    
    var temperament: [String] {
        return breed.temperament.split(separator: ",").map { String($0).replacingOccurrences(of: " ", with: "").lowercased() }
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
        return features
    }
    
    func temperament(for index: Int) -> String {
        return temperament[index]
    }
}
