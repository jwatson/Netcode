//
//  DribbbleAPIClient.swift
//  Netcode
//
//  Created by John Watson on 4/13/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Alamofire


final class APIClient {

    let configuration: APIConfiguration

    static var sessionConfiguration: NSURLSessionConfiguration = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        var headers = Alamofire.Manager.defaultHTTPHeaders
        headers["Accept"] = "application/json"
        config.HTTPAdditionalHeaders = headers

        return config
    }()

    let manager: Alamofire.Manager = {
        let manager = Alamofire.Manager(configuration: APIClient.sessionConfiguration)
        return manager
    }()

    init(configuration: APIConfiguration) {
        self.configuration = configuration
    }

}

// MARK: - Public

extension APIClient {

    func request(endpoint: APIEndpoint) -> Alamofire.Request {
        let URL = NSURL(string: configuration.baseURLString + "/" + endpoint.path)!

        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = endpoint.method.rawValue

        let (URLRequest, _) = endpoint.encoding.encode(mutableURLRequest, parameters: endpoint.parameters)
        let pendingRequest = manager.request(URLRequest)

        debugPrint(pendingRequest)
        return pendingRequest
    }

}
