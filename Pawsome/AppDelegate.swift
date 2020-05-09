//
//  AppDelegate.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

protocol AppDelegateProtocol {
    var context : AppContext! { get }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateProtocol {
    static let shared = UIApplication.shared.delegate as! AppDelegateProtocol
    var window: UIWindow?
    var context : AppContext!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        context = AppContext.context()
        let vc = RootTabBarViewController()
        window?.rootViewController = vc
        return true
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pawsome")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

