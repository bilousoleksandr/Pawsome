//
//  UIImage+Resizing.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeImage(targetWidth: CGFloat) -> UIImage? {

        let widthRatio  = targetWidth  / size.width
        let heightRatio = targetWidth / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.width * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height:  size.width * widthRatio)
        }
//        var newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - Breed Image

extension UIImage {
    static func catImage(for breed: String) -> UIImage {
        return UIImage(named: breed) ?? #imageLiteral(resourceName: "s1200")
    }
}
