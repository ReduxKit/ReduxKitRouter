//
//  ReduxKitRouter.swift
//  ReduxKitRouter
//
//  Created by Aleksander Herforth Rendtslev on 23/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import ReduxKit

/**

 applyMiddleware. Will chain the specified middleware so they are called before the reducers.

 - parameter middleware: middleware description

 - returns: return value description

 */
public func ReduxKitRouter<State>(router: Router)
    -> (((State?, Action) -> State, State?) -> Store<State>)
    -> (((State?, Action) -> State, State?) -> Store<State>) {

        return { next in
            return { reducer, initialState in

                // Initialize the mainRouter
                MainRouter.set(router)

                let store = applyMiddleware([ReduxKitRouterMiddleware])(next)(reducer, initialState)

                return store
            }
        }
}


class MainRouter {

    private static var sharedInstance: Router!

    static func get() -> Router {
        return sharedInstance
    }

    static func set(router: Router) {
        sharedInstance = router
    }
}
