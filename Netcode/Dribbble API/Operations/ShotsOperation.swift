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
        if cancelled {
            finished = true
            return
        }

        guard let JSON = JSON as? JSONObjectArray else {
            fatalError("Incorrect type!")
        }

        let importStart = CFAbsoluteTimeGetCurrent()

        context.performBlockAndWait { 
            for shot in JSON {
                if self.cancelled {
                    self.context.rollback()
                    self.finished = true
                    return
                }
                
                Shot.objectFromJSON(shot, inContext: self.context)
            }

            try! self.context.save()
        }

        defer {
            let importDuration = CFAbsoluteTimeGetCurrent() - importStart
            print(String(format: "[Shot import] duration=%.3fs", importDuration))
        }
    }

}
