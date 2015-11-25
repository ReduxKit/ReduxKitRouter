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
struct AppState: State{
}


func applicationReducer(state: State? = nil, action: Action) -> State{
    
    //let appState = state as! AppState?
    
    return
        AppState()
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
    
    private static var _viewController: UIViewController!
    var viewController: () -> UIViewController = {() -> UIViewController in
        if(ContainerRoute._viewController == nil){
            ContainerRoute._viewController = UIViewController()
        }
        return ContainerRoute._viewController
    }
 
    
}

/**
 *  Scanner routes
 */
struct ScannerRoute: Route{
    let name: String = "scanner"
    var navigationController:UINavigationController? = nil
    private static var _viewController: UIViewController!
    var viewController: () -> UIViewController = {() -> UIViewController in
        if(ScannerRoute._viewController == nil){
            ScannerRoute._viewController = UIViewController()
        }
        return ScannerRoute._viewController
    }
}

/**
 *  Login routes
 */
struct LoginRoute: Route{
    let name: String = "login"
    var navigationController:UINavigationController? = nil
    private static var _viewController: UIViewController!
    var viewController: () -> UIViewController = {() -> UIViewController in
        if(LoginRoute._viewController == nil){
            LoginRoute._viewController = UIViewController()
        }
        return LoginRoute._viewController
    }
    
}
