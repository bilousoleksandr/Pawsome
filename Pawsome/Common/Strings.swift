//
//  Strings.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

final class Strings {
    static let breeds = Strings.tr("Localizable", "breeds")
    static let singleBreed = Strings.tr("Localizable", "singleBreed")
    static let feed = Strings.tr("Localizable", "feed")
    static let origin = Strings.tr("Localizable", "origin")
    static let strangerFriendly = Strings.tr("Localizable", "strangerFriendly")
    static let socialNeeds = Strings.tr("Localizable", "socialNeeds")
    static let intelligence = Strings.tr("Localizable", "intelligence")
    static let energyLevel = Strings.tr("Localizable", "energyLevel")
    static let dogFriendly = Strings.tr("Localizable", "dogFriendly")
    static let experimental = Strings.tr("Localizable", "experimental")
    static let adaptability = Strings.tr("Localizable", "adaptability")
    static let childFriendly = Strings.tr("Localizable", "childFriendly")
    static let saved = Strings.tr("Localizable", "saved")
    static let similarCats = Strings.tr("Localizable", "similarCats")
    static let rare = Strings.tr("Localizable", "rare")
    static let natural = Strings.tr("Localizable", "natural")
    static let weight = Strings.tr("Localizable", "weight")
    static let kg = Strings.tr("Localizable", "kg")
    static let lifeSpan = Strings.tr("Localizable", "lifeSpan")
    static let years = Strings.tr("Localizable", "yr")
    static let personalImages = Strings.tr("Localizable", "personalImages")
    static let liked = Strings.tr("Localizable", "liked")
    static let singleImage = Strings.tr("Localizable", "singleImage")
    static let cantLoad = Strings.tr("Localizable", "cantLoad")
    static let tryAgain = Strings.tr("Localizable", "tryAgain")
}

extension Strings {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle.main, comment: "")
        let result = String(format: format, locale: Locale.current, arguments: args)
        return result
    }
}
