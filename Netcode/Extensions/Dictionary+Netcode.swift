//
//  Dictionary+Netcode.swift
//  Netcode
//
//  Created by John Watson on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation


enum JSONDecodingError: ErrorType {

    case NilValueForProperty
    case TypeMismatch

}

extension Dictionary where Key: StringLiteralConvertible, Value: AnyObject {

    func net_getValue<TypedReturn>(key: Key) throws -> TypedReturn {
        guard let valueObject = self[key] else {
            throw JSONDecodingError.NilValueForProperty
        }

        guard let value = valueObject as? TypedReturn else {
            throw JSONDecodingError.TypeMismatch
        }

        return value
    }

    func net_getOptionalValue<TypedReturn>(key: Key) throws -> TypedReturn? {
        if let valueObject = self[key] {
            if valueObject is NSNull {
                return nil
            }

            guard let value = valueObject as? TypedReturn else {
                throw JSONDecodingError.TypeMismatch
            }
            return value
        }

        return nil
    }

}
