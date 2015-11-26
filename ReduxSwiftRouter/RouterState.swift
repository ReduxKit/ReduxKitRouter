//
//  RouteState.swift
//  ReduxSwiftRouter
//
//  Created by Aleksander Herforth Rendtslev on 26/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import SwiftRedux

public protocol RoutableState: State{
    var router: RouterState {get set}
}


public struct RouterState{
    public var route: String!
    init(route: String){
        self.route = route
    }
}