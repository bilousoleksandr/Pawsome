//
//  BarButtonItem.swift
//  Pawsome
//
//  Created by Marentilo on 15.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct BarButtonItem {
    static func makeBackButton() -> UIBarButtonItem {
        let btn = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return btn
    }
}
