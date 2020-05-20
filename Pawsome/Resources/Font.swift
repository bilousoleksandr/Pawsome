//
//  Font.swift
//  Pawsome
//
//  Created by Marentilo on 20.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

enum Font {
    case navigationTitle
    case mainTitle
    case breedTitle
    case breedDetailsTitle
    case subtitle
    case breedDetailsText
    
    var uiFont : UIFont {
        switch self {
        case .navigationTitle: return UIFont.boldSystemFont(ofSize: 22)
        case .mainTitle: return UIFont.boldSystemFont(ofSize: 26)
        case .breedTitle: return UIFont.boldSystemFont(ofSize: 24)
        case .breedDetailsTitle: return UIFont.boldSystemFont(ofSize: 20)
        case .subtitle: return UIFont.systemFont(ofSize: 18)
        case .breedDetailsText: return UIFont.systemFont(ofSize: 16)
        }
    }
}
