//
//  Label.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct Label {
    
    static func makeTitleLabel (with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        UILabel()
            .color(textColor)
            .font(UIFont.boldSystemFont(ofSize: 30))
            .text(title)
            .lines(0)
            .lineBreak(.byWordWrapping)
    }
    
    static func makeSubtitleLabel(with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        UILabel()
            .color(textColor)
            .font(UIFont.systemFont(ofSize: 16))
            .text(title)
    }
    
    static func makeBreedDescriptionLabel(with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        UILabel()
            .font(UIFont.systemFont(ofSize: 16))
            .text(title)
            .lines(0)
            .lineBreak(.byWordWrapping)
            .color(textColor)
    }
}

extension UILabel {
    func color(_ clr: UIColor) -> UILabel {
        textColor = clr
        return self
    }
    
    func font(_ fnt: UIFont) -> UILabel {
        font = fnt
        return self
    }
    
    func lines(_ lns: Int) -> UILabel {
        numberOfLines = lns
        return self
    }
    
    func alignment(_ al: NSTextAlignment) -> UILabel {
        textAlignment = al
        return self
    }
    
    func text(_ txt: String?) -> UILabel {
        text = txt
        return self
    }
    
    func lineBreak(_ lb: NSLineBreakMode) -> UILabel {
        lineBreakMode = lb
        return self
    }
}
