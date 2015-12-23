//
//  RouterReducer.swift
//  ReduxKitRouter
//
//  Created by Aleksander Herforth Rendtslev on 26/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import ReduxKit

public func routerStateReducer(previousState: RouterState, action: Action) -> RouterState {

    // Declare the type of the state
    var state = previousState

    switch action {
    case let action as RouteChangeAction:
        state.route = action.rawPayload.route
        return state

    default:
        return state
    }
}
