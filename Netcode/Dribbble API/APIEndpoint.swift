//
//  APIEndpoint.swift
//  Netcode
//
//  Created by John Watson on 4/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Alamofire


protocol APIEndpoint {

    /// The encoding to use (e.g. `application/json`) for any request parameters.
    var encoding: Alamofire.ParameterEncoding { get }

    /// The HTTP method to use (e.g. `GET`).
    var method: Alamofire.Method { get }

    /// The endpoint's path, relative to the base URL.
    var path: String { get }

    /// The parameters to encode.
    var parameters: [String : AnyObject]? { get }

}
