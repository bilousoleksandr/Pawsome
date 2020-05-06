//
//  Label.swift
//  Pawsome
//
//  Created by Marentilo on 01.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct Label {
    
    static func makeTitleLabel (with title: String? = nil, textColor: UIColor? = UIColor.blus) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.text = title
        label.numberOfLines = 0
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.lineBreakMode = .byWordWrapping
        label.textColor = textColor
        return label
    }
    
    static func makeSubtitleLabel(with title: String? = nil, textColor: UIColor? = UIColor.blus) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = title
        label.textColor = textColor
        return label
    }
    
    /// multi line text label
    static func makeTextLabel(with title: String? = nil, textColor: UIColor? = UIColor.blus) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = textColor
        return label
    }
}
