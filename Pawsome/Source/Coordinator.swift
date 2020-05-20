//
//  Coordinator.swift
//  Pawsome
//
//  Created by Marentilo on 20.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

protocol Coordinator {
    var rootViewController : UINavigationController {get set}
    func start()
}

final class ApplicationCoordinator : Coordinator {
    var rootViewController : UINavigationController
    let window : UIWindow
    
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        let rootController = RootTabBarViewController()
        
        let breedsCoordinator = BreedsCoordinator()
        breedsCoordinator.rootViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "breedTabBar"), selectedImage: nil)
        let feedCoordinator = FeedCoordinator()
        feedCoordinator.rootViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "feedTabBar"), selectedImage: nil)
        let savedImagesCoordinator = SavedImagesCoordinator()
        savedImagesCoordinator.rootViewController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "savedImagesTabBar"), selectedImage: nil)
        childCoordinators = [breedsCoordinator, feedCoordinator, savedImagesCoordinator]
        
        childCoordinators.forEach({
            $0.start()
            $0.rootViewController.navigationBar.barTintColor = UIColor.lightBlue
            $0.rootViewController.navigationBar.titleTextAttributes = String.attributedString(UIFont.boldSystemFont(ofSize: 22),
                                                                                              UIColor.blus,
                                                                                              .center)
        })
        
        rootController.setViewControllers(childCoordinators.map{ $0.rootViewController }, animated: false)
        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}

// MARK: - BreedsCoordinator -
final class BreedsCoordinator : Coordinator {
    var rootViewController : UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        let breedsModel = BreedViewModelImplementation()
        breedsModel.coordinator = self
        let vc = BreedsCollectionViewController(breedViewModel: breedsModel)
        rootViewController.setViewControllers([vc], animated: true)
    }
    
    func presentBreedShortInfo(breed: Breed) {
        let breedModel = SingleBreeViewModelImplementation(breed: breed)
        let vc = BreedShortInfoViewController(breedMViewModel: breedModel)
        rootViewController.showFullScreen(vc)
    }
    
    func presentBreedFullInfo(breed : Breed) {
        let breedModel = SingleBreeViewModelImplementation(breed: breed)
        let vc = SingleBreedViewController(breedViewModel: breedModel)
        rootViewController.pushViewController(vc, animated: true)
    }
}

// MARK: - FeedCoordinator -
final class FeedCoordinator : Coordinator {
    var rootViewController : UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        let feedModel = FeedViewModelImplementation()
        feedModel.coordinator = self
        let vc = FeedCollectionViewController(feedViewModel: feedModel)
        rootViewController.setViewControllers([vc], animated: true)
    }
    
    func presentFullScreenImage(image : UIImage?) {
        rootViewController.showLagreImage(image)
    }
    
    func presentFullScreenFeed(with imageModel : Image? = nil, and category : Category? = nil) {
        let newImageModel = imageModel != nil ? FullScreenViewModelImplementation(imageModel) : FullScreenViewModelImplementation(nil, category)
        let vc = FullScreenViewController(fullScreenViewModel: newImageModel)
        rootViewController.pushViewController(vc, animated: true)
    }
}

// MARK: - SavedImagesCoordinator -
final class SavedImagesCoordinator : Coordinator {
    var rootViewController : UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
    }
    
    func start() {
        let savedImagesModel = SavedImagesViewModelImplementation()
        savedImagesModel.coordinator = self
        let vc = SavedImagesViewController(savedImagesModel: savedImagesModel)
        rootViewController.setViewControllers([vc], animated: true)
    }
    
    func showFullScreenImage(image : Image) {
        let viewModel = SingleImageViewModelImplementation(image: image)
        let vc = SingleImageViewController(sinleImageViewModel: viewModel)
        rootViewController.pushViewController(vc, animated: true)
    }
}


