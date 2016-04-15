//
//  APIClient+Shots.swift
//  Netcode
//
//  Created by John Watson on 4/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Alamofire
import Foundation


extension APIClient {

    enum Shots: APIEndpoint {

        case Create(title: String, image: NSData)
        case List
        case Read(id: Int)

        var encoding: Alamofire.ParameterEncoding {
            switch self {
            case .Create:
                return .JSON

            case .List,
                 .Read:
                return .URL
            }
        }

        var method: Alamofire.Method {
            switch self {
            case .Create:
                return .POST

            case .List,
                 .Read:
                return .GET
            }
        }

        var path: String {
            switch self {
            case .Create,
                 .List:
                return "shots"

            case .Read(let id):
                return "shots/\(id)"
            }
        }

        var parameters: [String: AnyObject]? {
            switch self {
            case .Create(let title, let image):
                return [
                    "title": title,
                    "image": image.base64EncodedStringWithOptions([]),
                ]

            case .List:
                return [
                    "access_token": "efd996a94bafbb3cd12abff895bb9dff92764a7b7511b83461c766c7385b2f5e",
                    "per_page": 100,
                ]

            case .Read:
                return nil
            }
        }

    }

}
