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
                try compareRoutes(MainRouter.get().mainNavigationController, routeName: routeAction.rawPayload.route, animated: routeAction.rawPayload.animated, dismissPrevious: routeAction.rawPayload.dismissPrevious)
            }catch{
                print(error)
            }
            
            return next(routeAction)
            
            
        }
    }
}

func compareRoutes(currentNavigationController: UINavigationController,routeName: String, animated: Bool = false, dismissPrevious: Bool = false) throws -> UIViewController{
    
    do{
        let router = MainRouter.get()
        var navigationController = currentNavigationController
        let route = try router.getRoute(routeName)
        let controller = route.viewController
        
        /**
        *  Run if the route is nested
        */
        if(routeName.componentsSeparatedByString("_").count > 1){
            let routes = routeName.componentsSeparatedByString("_")
            let parentRouteName = routeName.stringByReplacingOccurrencesOfString("_" + routes.last!, withString: "")
            let parentRoute = try router.getRoute(parentRouteName)
            
            do{
                try compareRoutes(currentNavigationController, routeName: parentRouteName)
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
    /**
    *  Dismiss Previous ViewController if dissmissPrevious is set
    */
    if(dismissPrevious){
        if(navigationController.viewControllers.count > 0){
            navigationController.viewControllers.removeFirst()
        }
    }

    
    if(navigationController.viewControllers.contains(controller)){
        navigationController.showViewController(controller, sender: nil)
    }else{
        navigationController.pushViewController(controller, animated: animated)
    }
    
}


