//
//  UIImage+Resizing.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

// MARK: - Breed Image
extension UIImage {
    static func catImage(for breed: String) -> UIImage {
        return UIImage(named: "\(breed)_back") ?? #imageLiteral(resourceName: "s1200")
    }
}
