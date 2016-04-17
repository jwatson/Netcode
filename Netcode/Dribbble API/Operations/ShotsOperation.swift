//
//  ShotsOperation.swift
//  Netcode
//
//  Created by John Watson on 4/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation


final class ShotsOperation: APIOperation {

    override func importJSONResponse(JSON: AnyObject) {
        guard let JSON = JSON as? JSONObjectArray else {
            fatalError("Incorrect type!")
        }

        context.performBlockAndWait {
            let shots: [Shot] = self.importJSONObjectArray(JSON)
            if shots.isEmpty {
                return
            }

            for (index, object) in shots.enumerate() {
                object.popularSortIndex = index
            }

            try! self.context.save()
        }
    }

}
