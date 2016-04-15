//
//  DribbbleShotsService.swift
//  Netcode
//
//  Created by John Watson on 4/14/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import Alamofire
import CoreData


typealias JSONObject        = [String: AnyObject]
typealias JSONObjectArray   = [JSONObject]


class APIOperation: NSOperation {

    let context: NSManagedObjectContext

    private let client: APIClient
    private let endpoint: APIEndpoint

    private var request: Alamofire.Request?

    // We can't access the `finished` property directly in Swift (yet), so we
    // have to hack around it a bit.
    private var internalFinished = false
    override var finished: Bool {
        get {
            return internalFinished
        }
        set {
            willChangeValueForKey("isFinished")
            internalFinished = newValue
            didChangeValueForKey("isFinished")
        }
    }

    init(client: APIClient, endpoint: APIEndpoint, context: NSManagedObjectContext) {
        self.client = client
        self.endpoint = endpoint
        self.context = context

        super.init()
    }

    override func start() {
        if cancelled {
            finished = true
            return
        }

        request = client.request(endpoint)
        request?.validate().responseJSON(completionHandler: handleJSONResponse)
    }

    override func cancel() {
        request?.cancel()
        super.cancel()
    }

}

// MARK: - Internal

extension APIOperation {

    func importJSONResponse(JSON: AnyObject) {
        fatalError("Subclasses must implement `\(#function)`")
    }

}

// MARK: - Private

private extension APIOperation {

    func handleJSONResponse(response: Response<AnyObject, NSError>) {
        if cancelled {
            finished = true
            return
        }

        let timeline = response.timeline
        let headers = response.response?.allHeaderFields as? [String: AnyObject] ?? [:]
        print("[\(endpoint.method) /\(endpoint.path)] \(requestTimelineLogString(timeline)) \(customHeadersLogString(headers))")

        switch response.result {
        case .Success(let JSON):
            importJSONResponse(JSON)

        case .Failure(let error):
            debugPrint("API request failed: \(error)")
        }

        finished = true
    }

    func requestTimelineLogString(timeline: Alamofire.Timeline) -> String {
        return String(
            format: "total=%.3fs request=%.3fs serialization=%.3fs latency=%.3fs",
            timeline.totalDuration, timeline.requestDuration, timeline.serializationDuration, timeline.latency
        )
    }

    func customHeadersLogString(headers: [String: AnyObject]) -> String {
        var blah = [String]()

        if let id = headers["X-Request-Id"] {
            blah.append("request-id=\(id)")
        }

        if let limit = headers["X-RateLimit-Limit"] {
            blah.append("ratelimit.limit=\(limit)")
        }

        if let remaining = headers["X-RateLimit-Remaining"] {
            blah.append("ratelimit.remaining=\(remaining)")
        }

        if let resetString = headers["X-RateLimit-Reset"] as? String, resetInterval = NSTimeInterval(resetString) {
            let date = NSDate.init(timeIntervalSince1970: resetInterval)
            blah.append("ratelimit.reset=\(DateFormatter.ISO8601Formatter.stringFromDate(date))")
        }

        return blah.joinWithSeparator(" ")
    }

}
