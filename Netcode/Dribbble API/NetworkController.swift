//
//  NetworkController.swift
//  Netcode
//
//  Created by John Watson on 4/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreData
import UIKit


final class NetworkController: NSObject {

    let client: APIClient
    let mainContext: NSManagedObjectContext

    let backgroundQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.name = "com.raizlabs.network-controller"
        queue.qualityOfService = .UserInitiated
        return queue
    }()

    private let backgroundContext: NSManagedObjectContext

    init(client: APIClient, managedObjectContext: NSManagedObjectContext) {
        self.client = client
        mainContext = managedObjectContext
        backgroundContext = mainContext.net_createBackgroundContext()

        super.init()

        registerForNotifications()
   }

}

// MARK: - Public

extension NetworkController {

    func loadHomeScreen(completion: () -> Void) -> NSFetchedResultsController {
        let listShots = ShotsOperation(client: client, endpoint: APIClient.Shots.List, context: backgroundContext)

        let completionOperation = NSBlockOperation(block: completion)
        completionOperation.addDependency(listShots)

        backgroundQueue.addOperation(listShots)
        NSOperationQueue.mainQueue().addOperation(completionOperation)

        let fetchRequest = NSFetchRequest(entityName: Shot.entityName)
        fetchRequest.sortDescriptors = Shot.defaultSortDescriptors
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 100

        return NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: mainContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

}

// MARK: - Private

private extension NetworkController {

    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.dynamicType.handleContextDidSave),
            name: NSManagedObjectContextDidSaveNotification,
            object: nil
        )

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(self.dynamicType.handleDidEnterBackground(_:)),
            name: UIApplicationDidEnterBackgroundNotification,
            object: nil
        )
     }

    @objc func handleContextDidSave(notification: NSNotification) {
        mainContext.performBlock {
            self.mainContext.mergeChangesFromContextDidSaveNotification(notification)
        }
    }

    @objc func handleDidEnterBackground(notification: NSNotification) {
        backgroundQueue.cancelAllOperations()
    }

}
