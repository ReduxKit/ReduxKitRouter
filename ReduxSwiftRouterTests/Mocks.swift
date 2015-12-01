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
        router: appState?.router != nil ? routerStateReducer(appState!.router, action: action) : RouterState(route: ApplicationRouter.RouteNames.login.rawValue)
    )
    
    return temp
    
}

/**
 *  Application router
 */
public struct ApplicationRouter: Router{
    public var mainNavigationController: UINavigationController = UINavigationController()
    public static let delimiter: String = "."
    public var routes: RouteDictionary = [
        RouteNames.container.rawValue: ContainerRoute(),
        RouteNames.container_scanner.rawValue: ScannerRoute(),
        RouteNames.login.rawValue :LoginRoute()
    ]
    
    
    public enum RouteNames:String{
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
    var navigationController:UINavigationController? = UINavigationController()
    
    func getViewController() -> UIViewController {
        return ContainerViewController()
    }
}

/**
 *  Scanner routes
 */
struct ScannerRoute: Route{
    let name: String = "scanner"
    var navigationController:UINavigationController? = nil
    func getViewController() -> UIViewController {
        return UIViewController()
    }
}

/**
 *  Login routes
 */
struct LoginRoute: Route{
    let name: String = "login"
    var navigationController:UINavigationController? = nil
    func getViewController() -> UIViewController {
        return LoginViewController()
    }
}

public class ContainerViewController :UIViewController{
}
public class LoginViewController :UIViewController{
}
