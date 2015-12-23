//
//  RouteState.swift
//  ReduxKitRouter
//
//  Created by Aleksander Herforth Rendtslev on 26/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


public struct RouterState {

    public var route: String!

    public var animated: Bool!

    public var dismissPrevious: Bool!

    public init(route: String, animated: Bool = false, dismissPrevious: Bool = false) {
        self.route = route
        self.animated = animated
        self.dismissPrevious = dismissPrevious
    }
}
