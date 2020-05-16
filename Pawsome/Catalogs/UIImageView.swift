//
//  UIImageView.swift
//  Pawsome
//
//  Created by Marentilo on 15.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

extension UIImageView {
    func makeRounded(radius : CGFloat) {
        layer.borderWidth = 1.0
        layer.masksToBounds = false
        layer.borderColor = UIColor.blus.cgColor
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
