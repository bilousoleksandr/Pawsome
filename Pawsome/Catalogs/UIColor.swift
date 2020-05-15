//
//  UIColor.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UIColor {
    static let blus = UIColor.rgb(r: 48, g: 64, b: 87)
    static let salmon = UIColor.rgb(r: 229, g: 76, b: 76)
    static let indianred = UIColor.rgb(r: 196, g: 78, b: 78)
    static let lightLightGrey = UIColor.rgb(r: 147, g: 156, b: 166)
    static let lightLightYellow = UIColor.rgb(r: 237, g: 233, b: 226)
    static let lightBlue = UIColor.rgb(r: 236, g: 242, b: 248)
    static let newWeight = UIColor.rgb(r: 251, g: 251, b: 251)
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
}
