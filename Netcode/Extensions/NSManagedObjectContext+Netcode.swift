//
//  NSManagedObjectContext+Netcode.swift
//  Netcode
//
//  Created by John Watson on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreData


extension NSManagedObjectContext {

    public func net_insertObject<A: NSManagedObject where A: ManagedObject>() -> A {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else {
            fatalError("Wrong object type!")
        }

        return object
    }

    public func net_createBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }

}
