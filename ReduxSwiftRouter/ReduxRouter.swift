//
//  ReduxRouter.swift
//  ReduxSwiftRouter
//
//  Created by Aleksander Herforth Rendtslev on 23/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import SwiftRedux


/**
 applyMiddleware. Will chain the specified middlewares so they are called before the reducers.
 
 - parameter middlewares: middlewares description
 
 - returns: return value description
 */
public func reduxRouter(router: Router) -> StoreEnhancer{
    return { (next:StoreCreator) -> StoreCreator in
        return { (reducer: Reducer, initialState: State?) -> Store in
            
            // Initialize the mainRouter
            MainRouter.set(router)
            
            
            
            let store = applyMiddlewares([reduxRouterMiddleware])(next)(reducer: reducer, initialState: initialState)
            
            // Force error if state is not routable
            
            do{
                guard let state = store.getState() as? RoutableState else{
                    
                    throw RouteErrors.AppStateNotImplementingRoutableState
                }
                // Initialize route
                store.dispatch(RouteChangeAction(route: state.router.route))

            }
            catch{
                print("is your state implementing the RoutableState protocol?")
            }
            
            return store
        }
    }
}

class MainRouter{
    private static var sharedInstance: Router!
    
    static func get() -> Router{
        return sharedInstance
    }
    
    static func set(router: Router){
        sharedInstance = router
    }
}