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
            
            guard let routeAction = action as? RouteChangeAction else{
                return next(action)
            }
            
            do{
                
                try navigateToRoute(routeAction)
            }catch{
                print(error)
            }
            
            return next(routeAction)
            
            
        }
    }
}

func navigateToRoute(routeAction: RouteChangeAction) throws{
    
    /// Get the applications mainRouter from the MainRouter sharedInstance
    let router = MainRouter.get()
    
    /// Fetch the next route from the router
    let nextRoute = try router.getRoute(routeAction.rawPayload.route)
    
    /// Fetch the main navigation controller from the router
    let navigationController = MainRouter.get().mainNavigationController
 
    try compareRoutes(navigationController, nextRoute: nextRoute, animated: routeAction.rawPayload.animated, dismissPrevious: routeAction.rawPayload.dismissPrevious)
}

func compareRoutes(currentNavigationController: UINavigationController, nextRoute: Route, animated: Bool = false, dismissPrevious: Bool = false) throws -> UIViewController{
    
    do{
        let router = MainRouter.get()
        var navigationController = currentNavigationController
        let controller = nextRoute.getViewController()
        let routeName = nextRoute.name
        
        /**
        *  Run if the route is nested
        */
        if(routeName.componentsSeparatedByString("_").count > 1){
            let routes = routeName.componentsSeparatedByString("_")
            let parentRouteName = routeName.stringByReplacingOccurrencesOfString("_" + routes.last!, withString: "")
            let parentRoute = try router.getRoute(parentRouteName)
            
            do{
                try compareRoutes(currentNavigationController, nextRoute : parentRoute, animated: animated, dismissPrevious: dismissPrevious)
                navigationController = parentRoute.navigationController!
                
                /**
                *  Navigate to the specified viewController
                */
                goToViewController(navigationController, controller: controller, animated: animated, dismissPrevious: dismissPrevious)

            }catch{
                throw RouteErrors.SubRoutesOnNonNavigationController
            }
        }else{
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
    
    var viewControllers = navigationController.viewControllers
    print(viewControllers.count)
    
    // Show the view controller
    navigationController.pushViewController(controller, animated: animated)
    
    /**
    *  Dismiss Previous ViewController if dissmissPrevious is set
    */
    if(dismissPrevious){
        navigationController.viewControllers = navigationController.viewControllers.reverse()
        navigationController.popToViewController(controller, animated: false)
    }
    
    viewControllers = navigationController.viewControllers
    print(viewControllers.count)
}


