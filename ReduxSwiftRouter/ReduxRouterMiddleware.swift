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
                    try navigateToRoute(store, action: action)
                }catch{
                    print(error)
                }
                
                return next(action)
            case let action as RouteBackAction:
                
                do{
                    try goBackToPreviousRoute(store, action: action)
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

func goBackToPreviousRoute(store: MiddlewareApi, action: RouteBackAction) throws{
    /**
    Not implemented
    */
}

func navigateToRoute(store: MiddlewareApi, action: RouteChangeAction) throws{
    let routerState = store.getState() as! RoutableState
    let previousRoute = routerState.router.route

    
    /// Fetch the next route from the router
    let routeName = action.rawPayload.route
    
    /// Fetch the main navigation controller from the router
    let navigationController = MainRouter.get().mainNavigationController
    
    try compareRoutes(navigationController, routeName: routeName, previousRouteName: previousRoute, animated: action.rawPayload.animated, dismissPrevious: action.rawPayload.dismissPrevious)
}

func compareRoutes(currentNavigationController: UINavigationController, routeName: String, previousRouteName: String, animated: Bool = false, dismissPrevious: Bool = false) throws -> UIViewController{
    
    do{
        var router = MainRouter.get()
        var navigationController = currentNavigationController
        let route = try router.getRoute(routeName)
        let controller = route.viewController
        
        /**
        *  Run if the route is nested
        */
        if(routeName.componentsSeparatedByString("_").count > 1){
            /// Get the routeName of the parent
            let routes = routeName.componentsSeparatedByString("_")
            let parentRouteName = routeName.stringByReplacingOccurrencesOfString("_" + routes.last!, withString: "")
            
            /// Get the previous parent route
            let parentRoutes = previousRouteName.componentsSeparatedByString("_")
            let previousParentName = previousRouteName.stringByReplacingOccurrencesOfString("_" + parentRoutes.last!, withString: "")
            
            let parentRoute = router.activeRoute.name == parentRouteName ? router.activeRoute : try router.getRoute(parentRouteName)
            
            do{
                
                navigationController = parentRoute.navigationController!
                
                /**
                *  Navigate to the specified parent ViewController
                */
                goToViewController(navigationController, controller: controller, animated: animated)
   
                if(previousParentName != parentRouteName){
                    try compareRoutes(currentNavigationController, routeName: parentRouteName, previousRouteName: previousParentName, animated: animated, dismissPrevious: dismissPrevious)
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
            goToViewController(navigationController, controller: controller, animated: animated, dismissPrevious: dismissPrevious)
        }
        
        return controller
    }catch{
        throw RouteErrors.SubRoutesOnNonNavigationController
    }
    
}

func goToViewController(navigationController: UINavigationController, controller: UIViewController, animated: Bool = false, dismissPrevious: Bool = false){
    
    /**
    *  Dismiss Previous ViewController if dissmissPrevious is set
    */
    if(dismissPrevious){
        //navigationController.viewControllers = navigationController.viewControllers.reverse()
        navigationController.viewControllers.forEach{viewController in
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
        navigationController.setViewControllers([controller], animated: animated)
    }else{
        
        // Show the view controller
        navigationController.pushViewController(controller, animated: animated)
    }
}


