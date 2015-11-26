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

func compareRoutes(currentNavigationController: UINavigationController, routeName: String, animated: Bool = false, dismissPrevious: Bool = false) throws -> UIViewController{
    let router = MainRouter.get()
    var navigationController = currentNavigationController
    
    /**
    *  Run if the route is nested
    */
    if(routeName.componentsSeparatedByString("_").count > 1){
            let routes = routeName.componentsSeparatedByString("_")
            let parentRoute = routeName.stringByReplacingOccurrencesOfString("_" + routes.last!, withString: "")
        
        do{
            let parentController  = try compareRoutes(currentNavigationController, routeName: parentRoute)
            navigationController = parentController.navigationController!
        }catch{
            throw RouteErrors.SubRoutesOnNonNavigationController
        }
    }
    
    /**
    *  Run after the route has been decomposed
    */
    do{
        let route = try router.getRoute(routeName)
        let controller = route.viewController()
        
        
        print(navigationController.viewControllers.count)
        /**
        *  Dismiss Previous ViewController if dissmissPrevious is set
        */
        if(dismissPrevious){
            navigationController.viewControllers.removeFirst()
        }
        print(navigationController.viewControllers.count)
        /**
        *  Navigate to the specified viewController
        */
        goToViewController(navigationController, controller: controller, animated: animated)
        
        
        return controller
    }catch{
        throw RouteErrors.SubRoutesOnNonNavigationController
    }

}

func goToViewController(navigationController: UINavigationController, controller: UIViewController, animated: Bool = false){
    if(navigationController.viewControllers.contains(controller)){
        navigationController.showViewController(controller, sender: nil)
    }else{
        navigationController.pushViewController(controller, animated: animated)
    }
    
}


