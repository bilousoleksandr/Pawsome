//
//  RootTabBarViewController.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class RootTabBarViewController : UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.indianred
        tabBar.barTintColor = UIColor.lightBlue
    }
}

// MARK: - UITabBarDelegate
extension RootTabBarViewController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.subviews.forEach { $0.layer.removeAllAnimations() }
        guard let firstIndex = tabBar.items?.firstIndex(of: item), tabBar.subviews.count > firstIndex + 1 else { return }
        let imageView = tabBar.subviews[firstIndex + 1]
        imageView.makePulse()
    }
}

