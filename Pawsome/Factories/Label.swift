//
//  Label.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct Label {
    /// Standart title label with two lines
    static func makeTitleLabel (with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        UILabel()
            .color(textColor)
            .font(UIFont.boldSystemFont(ofSize: 26))
            .text(title)
            .lines(2)
            .lineBreak(.byWordWrapping)
    }
    
    /// Title for breeds in collectionView
    static func makeBreedTitleLabel (with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        Label.makeTitleLabel(with: title)
            .font(UIFont.boldSystemFont(ofSize: 24))
            .alignment(.center)
    }
    
    /// Title for breeds in collectionView
    static func makeBreedDetailsTitleLabel (with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        Label.makeTitleLabel()
            .color(textColor)
            .text(title)
            .font(UIFont.boldSystemFont(ofSize: 20))
            .alignment(.center)
    }
    
    static func makeSubtitleLabel(with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        UILabel()
            .color(textColor)
            .font(UIFont.systemFont(ofSize: 18))
            .text(title)
            .adjustFontSize()
    }
    
    /// Subtitle label with 2 lines and word wrapping style
    static func makeBreedDetailsLabel(with title: String? = nil, textColor: UIColor = UIColor.blus) -> UILabel {
        UILabel()
            .color(textColor)
            .font(UIFont.systemFont(ofSize: 16))
            .text(title)
            .lines(2)
            .lineBreak(.byWordWrapping)
    }
    
    /// Multiline title for breed description
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
    
    func adjustFontSize(_ adjust : Bool = true) -> UILabel {
        adjustsFontSizeToFitWidth = adjust
        return self
    }
}
