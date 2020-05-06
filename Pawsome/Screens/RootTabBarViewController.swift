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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let breedsVC = BreedsCollectionViewController(collectionViewLayout: layout)
        breedsVC.tabBarItem = UITabBarItem(title: Strings.breeds, image: #imageLiteral(resourceName: "cat"), selectedImage: nil)
        
        let feedVC = FeedCollectionViewController()
        feedVC.tabBarItem = UITabBarItem(title: Strings.feed, image: #imageLiteral(resourceName: "cat"), selectedImage: nil)
        
        let navControllers = [breedsVC, feedVC].map { UINavigationController(rootViewController: $0) }
        setViewControllers(navControllers, animated: true)
    }
}
