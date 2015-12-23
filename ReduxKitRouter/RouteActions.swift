//
//  RouteChangeAction.swift
//  ReduxKitRouter
//
//  Created by Aleksander Herforth Rendtslev on 23/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import ReduxKit


public protocol RouteAction: SimpleStandardAction {}

public struct RouteChangeAction: RouteAction {

    public let meta: Any? = nil
    public let error: Bool = false
    public let rawPayload: Payload

    public init(route: Payload) {
        rawPayload = route
    }

    public struct Payload {

        public let route: String
        public let dismissPrevious: Bool
        public let animated: Bool

        public init(route: String, dismissPrevious: Bool = false, animated: Bool = false) {
            self.route = route
            self.dismissPrevious = dismissPrevious
            self.animated = animated
        }
    }
}


public struct RouteChangeErrorAction: RouteAction {

    public let meta: Any? = nil
    public let error: Bool = true
    public let rawPayload: String
}


public struct RouteBackAction: RouteAction {

    public let meta: Any? = nil
    public let error: Bool = false
    public let rawPayload: Any? = nil
}
