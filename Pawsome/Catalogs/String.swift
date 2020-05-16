//
//  String.swift
//  Pawsome
//
//  Created by Marentilo on 15.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

extension String {
    private func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var capitalizedFirst : String {
        capitalizeFirstLetter()
    }
}
