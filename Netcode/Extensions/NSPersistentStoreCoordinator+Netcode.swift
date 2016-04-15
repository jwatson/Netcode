//
//  NSPersistentStoreCoordinator+Netcode.swift
//  Netcode
//
//  Created by John Watson on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreData


extension NSPersistentStoreCoordinator {

    func net_destroySQLiteStoreAtURL(storeURL: NSURL) {
        try! destroyPersistentStoreAtURL(storeURL, withType: NSSQLiteStoreType, options: [:])
    }

}
