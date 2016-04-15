//
//  APIConfiguration.swift
//  Netcode
//
//  Created by John Watson on 4/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation


protocol APIConfiguration {

    var baseURLString: String { get }

}

extension APIConfiguration {

    var baseURL: NSURL? {
        return NSURL(string: baseURLString)
    }

}
