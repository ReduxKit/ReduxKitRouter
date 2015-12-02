//
//  ReduxRouter.swift
//  ReduxSwiftRouter
//
//  Created by Aleksander Herforth Rendtslev on 23/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import SwiftRedux

func reduxRouterMiddleware(store: MiddlewareApi) -> MiddlewareReturnFunction{
    return {(next: Dispatch) in
        return{(action:Action) in
            
            
            switch action{
            case let action as RouteChangeAction:
                
                do{
                    try handleRouteChangeAction(store, action: action)
                }catch{
                    print(error)
                }
                
                return next(action)
            case let action as RouteBackAction:
                
                do{
                    try handleRouteBackAction(store, action: action)
                }catch{
                    print(error)
                }
                
                return next(action)
            default:
                return next(action)
            }
        }
    }
}

/**
 Will handle RouteBackAction
 
 - parameter store:  <#store description#>
 - parameter action: <#action description#>
 */
func handleRouteBackAction(store: MiddlewareApi, action: RouteBackAction) throws{
    /**
    Not implemented
    */
}

/**
 Will handle RouteChangeAction
 
 - parameter store:  <#store description#>
 - parameter action: <#action description#>
 */
func handleRouteChangeAction(store: MiddlewareApi, action: RouteChangeAction) throws{
    let routerState = store.getState() as! RoutableState
    let previousRoute = routerState.router.route
    
    // Fetch the mainRouter
    let router = MainRouter.get()
    
    /// Fetch the next route from the router
    let routeName = action.rawPayload.route
    
    // Fetch a new instance of the route
    let route = try router.getRoute(routeName)
    
    /// Fetch the main navigation controller from the router
    let navigationController = MainRouter.get().mainNavigationController
    
    try navigateToRoute(navigationController, routeName: routeName, previousRouteName: previousRoute, route: route,  animated: action.rawPayload.animated, dismissPrevious: action.rawPayload.dismissPrevious)
}

/**
 This function will transition to the specified route. It will deduce whether to transition on the mainNavigationController or whether the transition should happen on a child viewController on a nested route.
 
 - parameter currentNavigationController: The currentNavigationController
 - parameter routeName:                   The full name of the route to transition to.
 - parameter previousRouteName:           The name of the previous route
 - parameter route:                       The route that is to be navigated to
 - parameter animated:                    Whether to animate
 - parameter dismissPrevious:             Whether to dismiss previous routes
 
 - throws: Can throw RouteErrors.SubRoutesOnNavigationController
 */
func navigateToRoute(currentNavigationController: UINavigationController, routeName: String,  previousRouteName: String, route: Route, animated: Bool = false, dismissPrevious: Bool = false) throws {
    
    do{
        var router = MainRouter.get()
        let controller = route.viewController
        
        /**
        *  Run if the route is nested
        */
        if(routeName.componentsSeparatedByString("_").count > 1){
            /// Get the routeName of the parent
            let routes = routeName.componentsSeparatedByString("_")
            let parentRouteName = routeName.stringByReplacingOccurrencesOfString("_" + routes.last!, withString: "")
            
            /// Get the previous parent route
            let previousRoutes = previousRouteName.componentsSeparatedByString("_")
            let previousParentName = previousRouteName.stringByReplacingOccurrencesOfString("_" + previousRoutes.last!, withString: "")
            
            /// If the active route is equal to the parentRouteName of the next route, return the current activeRoute instance. Else fetch a new instance
            let parentRoute = router.activeRoute.name == parentRouteName ? router.activeRoute : try router.getRoute(parentRouteName)
            
            do{
                /**
                *  Fetch the parentRoute's navigationController. This will throw an error if the navigationController is not set
                */
                guard let navigationController = parentRoute.navigationController else{
                    throw RouteErrors.SubRoutesOnNonNavigationController
                }
                
                /**
                *  Navigate to the specified parent ViewController
                */
                goToViewController(navigationController, controller: controller, animated: animated)
   
                /**
                *  If the previousParentRoute is not equal to the current parent route,
                */
                if(previousParentName != parentRouteName){
                    try navigateToRoute(currentNavigationController, routeName: parentRouteName, previousRouteName: previousParentName, route: parentRoute, animated: animated, dismissPrevious: dismissPrevious)
                }
                
                
            }catch{
                throw RouteErrors.SubRoutesOnNonNavigationController
            }
        }else{
            // update the currently active route
            router.activeRoute = route
            
            // Update the router
            MainRouter.set(router)
            
            /**
            *  Navigate to the specified viewController
            */
            goToViewController(currentNavigationController, controller: controller, animated: animated, dismissPrevious: dismissPrevious)
        }
    }catch{
        throw RouteErrors.SubRoutesOnNonNavigationController
    }
    
}

/**
 Will navigate to the specified controller on the given navigation controller.
 The optionals will specify whether to animate and whether to dismiss previous controllers on the stack
 
 - parameter navigationController: The navigationController to push the view controller on
 - parameter controller:           The ViewController to push onto the stack
 - parameter animated:             Whether to animate
 - parameter dismissPrevious:      Whether to dismiss previous viewControllers from the stack
 */
func goToViewController(navigationController: UINavigationController, controller: UIViewController, animated: Bool = false, dismissPrevious: Bool = false){
    
    /**
    *  Dismiss Previous ViewController if dissmissPrevious is set
    */
    if(dismissPrevious){
        /**
        *  Will remove all previous viewControllers and set the new stack to the specified controller
        */
        navigationController.setViewControllers([controller], animated: animated)
    }else{
        
        /**
        *  Will push the specified controller on the stack
        */
        navigationController.pushViewController(controller, animated: animated)
    }
}


