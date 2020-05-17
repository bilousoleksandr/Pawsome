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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let breedsVC = BreedsCollectionViewController(collectionViewLayout: layout)
        breedsVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "breedTabBar"), selectedImage: nil)
        
        let feedVC = FeedCollectionViewController()
        feedVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "feedTabBar"), selectedImage: nil)
        
        let savedVC = SavedImagesViewController()
        savedVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "savedImagesTabBar"), selectedImage: nil)
        
        let navControllers = [breedsVC, feedVC, savedVC].map { vc -> UINavigationController in
            let nc = UINavigationController(rootViewController: vc)
            nc.navigationBar.barTintColor = UIColor.lightBlue
            nc.navigationBar.titleTextAttributes = String.attributedString(UIFont.boldSystemFont(ofSize: 22), UIColor.blus, .center)
            return nc
        }
        setViewControllers(navControllers, animated: true)
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

