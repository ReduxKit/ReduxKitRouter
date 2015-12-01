//
//  Mocks.swift
//  ReduxSwiftRouter
//
//  Created by Aleksander Herforth Rendtslev on 24/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Foundation
import SwiftRedux
@testable import ReduxSwiftRouter

/**
 *  Application state
 */
struct AppState: RoutableState{
    var router: RouterState
}



func applicationReducer(state: State? = nil, action: Action) -> State{
    
    let appState = state as? AppState
    
    let temp = AppState(
        router: appState?.router != nil ? routerStateReducer(appState!.router, action: action) : RouterState(route: ApplicationRouter.Routes.login.rawValue)
    )
    
    return temp
    
}

/**
 *  Application router
 */
public struct ApplicationRouter: Router{
    public var mainNavigationController: UINavigationController = UINavigationController()
    public var activeRoute: Route = LoginRoute.make()

    
    public func getRoute(route: String) throws -> Route {
        
        guard let routeEnum = Routes(rawValue: route) else{
            throw RouteErrors.RouteNotFound
        }
        
        switch routeEnum{
            case Routes.container:
                return ContainerRoute.make()
            case .container_scanner:
                return ScannerRoute.make()
            case .login:
                return LoginRoute.make()
        }
    }
    
    public enum Routes: String{
        case container
        case container_scanner
        case login
    }
}


/**
 *  Container routes
 */
struct ContainerRoute: Route{
    let name: String = "container"
    let navigationController:UINavigationController?
    let viewController: UIViewController
    
    static func make() -> Route {
        return ContainerRoute(navigationController: UINavigationController(), viewController: ContainerViewController())
    }
}

/**
 *  Scanner routes
 */
struct ScannerRoute: Route{
    let name: String = "scanner"
    let navigationController:UINavigationController? = nil
    let viewController: UIViewController
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    static func make() -> Route {
        return ScannerRoute(viewController: UIViewController())
    }
}

/**
 *  Login routes
 */
struct LoginRoute: Route{
    let name: String = "login"
    let navigationController:UINavigationController? = nil
    let viewController: UIViewController
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
    
    static func make() -> Route {
        return LoginRoute(viewController: LoginViewController())
    }
}

public class ContainerViewController :UIViewController{
}
public class LoginViewController :UIViewController{
}
