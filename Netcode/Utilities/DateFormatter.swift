//
//  DateFormatter.swift
//  Netcode
//
//  Created by John Watson on 4/15/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Foundation


struct DateFormatter {

    static var ISO8601Formatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()

    static func dateFromISO8601String(dateString: String) -> NSDate {
        guard let date = DateFormatter.ISO8601Formatter.dateFromString(dateString) else {
            return NSDate()
        }

        return date
    }

}
