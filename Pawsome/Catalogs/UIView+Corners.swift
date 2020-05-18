//
//  UIView+Corners.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

// MARK: - Style: Corners, Border, Shadow
extension UIView {
    func roundCorners(radius: CGFloat, cornersMask : CACornerMask = CACornerMask(arrayLiteral: .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner)) {
        layer.cornerRadius = radius
        layer.maskedCorners = cornersMask
    }
    
    func makeBorders (radius: CGFloat = 0, width : CGFloat, color: UIColor = UIColor.blus) {
        roundCorners(radius: radius)
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        clipsToBounds = true
    }
    
    func makeShadow () {
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.shadowOpacity = 1
        layer.shadowOffset  = .zero
        layer.shadowRadius = 3
    }
}

// MARK: - Blur View
extension UIView {
    func makeBlur() {
        let visualEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        addSubview(visualEffectView)
        visualEffectView.frame = frame
    }
}
