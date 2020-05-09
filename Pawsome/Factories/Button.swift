//
//  Button.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct Button {
    static func makeButton(_ normalStateImage : UIImage, _ selectedStateImage : UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(normalStateImage, for: .normal)
        button.setImage(selectedStateImage, for: .selected)
        return button
    }
}
