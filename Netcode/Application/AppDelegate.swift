//
//  AppDelegate.swift
//  Netcode
//
//  Created by John Watson on 4/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreData
import UIKit


struct Configuration: APIConfiguration {

    var baseURLString: String {
        return "https://api.dribbble.com/v1"
    }

}

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let storeURL = NSURL.documentsURL.URLByAppendingPathComponent("Model.sqlite")
        print("Core Data URL: \(storeURL)")

        let bundles = [NSBundle(forClass: Shot.self)]
        guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("Model not found!")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
//        psc.net_destroySQLiteStoreAtURL(storeURL)
        try! psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)

        let mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc

        let client = APIClient(configuration: Configuration())
        let networkController = NetworkController(client: client, managedObjectContext: mainManagedObjectContext)

        let rootWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        rootWindow.backgroundColor = .whiteColor()
        rootWindow.rootViewController = ViewController(networkController: networkController)
        rootWindow.makeKeyAndVisible()
        window = rootWindow

        return true
    }

}
