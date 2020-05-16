//
//  String.swift
//  Pawsome
//
//  Created by Marentilo on 15.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

// MARK: - Capitalized first letter
extension String {
    private func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    var capitalizedFirst : String {
        capitalizeFirstLetter()
    }
}

// MARK: - NSAttributedString
extension String {
    static func attributedString(_ font : UIFont? = nil, _ txtColor: UIColor? = nil, _ aligment: NSTextAlignment? = nil) -> [NSAttributedString.Key: AnyObject] {
        var attributedString = [NSAttributedString.Key : AnyObject]()
        if let newFont = font {
            attributedString[NSAttributedString.Key.font] = newFont
        }
        if let newTxtColor = txtColor {
            attributedString[NSAttributedString.Key.foregroundColor] = newTxtColor
        }
        if let newAligment = aligment {
            let patagraphStyle = NSMutableParagraphStyle()
            patagraphStyle.alignment = newAligment
            attributedString[NSAttributedString.Key.paragraphStyle] = patagraphStyle
        }
        return attributedString
    }
}
