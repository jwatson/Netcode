//
//  Shot.swift
//  Netcode
//
//  Created by John Watson on 4/6/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import CoreData
import Foundation


public final class Shot: NSManagedObject {

    @NSManaged public private(set) var id: Int
    @NSManaged public private(set) var title: String?
    @NSManaged public private(set) var desc: String?
    @NSManaged public private(set) var animated: Bool
    @NSManaged public private(set) var createdAt: NSDate
    @NSManaged public private(set) var updatedAt: NSDate

    static func objectFromJSON(JSON: JSONObject, inContext context: NSManagedObjectContext) -> Shot {
        do {
            let primaryKeyValue: Int = try JSON.net_getValue("id")

            let predicate = NSPredicate(format: "%K == %ld", Shot.primaryKey, primaryKeyValue)
            let shot = Shot.findOrCreateInContext(context, matchingPredicate: predicate, configure: nil)

            shot.id = primaryKeyValue
            shot.title = try JSON.net_getOptionalValue("title")
            shot.desc = try JSON.net_getOptionalValue("description")
            shot.animated = try JSON.net_getValue("animated")
            shot.createdAt = DateFormatter.dateFromISO8601String(try JSON.net_getValue("created_at"))
            shot.updatedAt = DateFormatter.dateFromISO8601String(try JSON.net_getValue("updated_at"))

            return shot
        }
        catch {
            fatalError("\(error)")
        }
    }

}

extension Shot: ManagedObject {

    public static var entityName: String {
        return "Shot"
    }

    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "updatedAt", ascending: false)]
    }

    public static var primaryKey: String {
        return "id"
    }

}
