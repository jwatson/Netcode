//
//  NSURL+Netcode.swift
//  Netcode
//
//  Created by John Watson on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation


extension NSURL {

    static var documentsURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(
            .DocumentDirectory,
            inDomain: .UserDomainMask,
            appropriateForURL: nil,
            create: true
        )
    }

}
