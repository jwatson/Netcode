//
//  ManagedObject.swift
//  Netcode
//
//  Created by John Watson on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreData


public protocol ManagedObject: class {

    /// The managed object's name in the Core Data model.
    static var entityName: String { get }

    /// Default sort descriptors for use when constructing fetch requests.
    static var defaultSortDescriptors: [NSSortDescriptor] { get }

    /// The primary object identifier.
    static var primaryKey: String { get }

    static func objectFromJSON(JSON: JSONObject, inContext context: NSManagedObjectContext) -> Self

}

extension ManagedObject where Self: NSManagedObject {

    public static func fetchInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self] {
        let request = NSFetchRequest(entityName: Self.entityName)
        configurationBlock(request)

        guard let result = try! context.executeFetchRequest(request) as? [Self] else {
            fatalError("Fetched objects have the wrong type!")
        }

        return result
    }

    public static func materializedObjectInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        for obj in context.registeredObjects where !obj.fault {
            guard let result = obj as? Self where predicate.evaluateWithObject(result) else {
                continue
            }

            return result
        }

        return nil
    }

    public static func findOrFetchInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        guard let obj = materializedObjectInContext(context, matchingPredicate: predicate) else {
            return fetchInContext(context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }

        return obj
    }

    public static func findOrCreateInContext(context: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: (Self -> ())?) -> Self {
        guard let obj = findOrFetchInContext(context, matchingPredicate: predicate) else {
            let newObject: Self = context.net_insertObject()
            configure?(newObject)
            return newObject
        }

        return obj
    }

}
