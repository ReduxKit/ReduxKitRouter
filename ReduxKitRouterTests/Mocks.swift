//
//  Mocks.swift
//  ReduxKitRouter
//
//  Created by Aleksander Herforth Rendtslev on 24/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import UIKit
import ReduxKit
@testable import ReduxKitRouter

// MARK: - State

struct AppState: RoutableState {
    var router: RouterState
}


// MARK: - Typealias

typealias AppStore = Store<AppState>


// MARK: - Reducers

func applicationReducer(state: AppState? = nil, action: Action) -> AppState {

    return AppState(
        router: state?.router != nil ? routerStateReducer(state!.router, action: action) : RouterState(route: ApplicationRouter.Routes.login.rawValue)
    )
}

// MARK: - Routers

struct ApplicationRouter: Router {

    var mainNavigationController: UINavigationController = UINavigationController()
    var activeRoute: Route = LoginRoute.make()

    func getRoute(route: String) throws -> Route {

        guard let routeEnum = Routes(rawValue: route) else { throw RouteErrors.RouteNotFound }

        switch routeEnum {
            case Routes.container:
                return ContainerRoute.make()
            case .container_scanner:
                return ScannerRoute.make()
            case .login:
                return LoginRoute.make()
        }
    }

    enum Routes: String {
        case container
        case container_scanner
        case login
    }
}


// MARK: - Routes

struct ContainerRoute: Route {
    let name: String = "container"
    let navigationController: UINavigationController?
    let viewController: UIViewController

    static func make() -> Route {
        return ContainerRoute(navigationController: UINavigationController(), viewController: ContainerViewController())
    }
}


struct ScannerRoute: Route {
    let name: String = "scanner"
    let navigationController: UINavigationController? = nil
    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func make() -> Route {
        return ScannerRoute(viewController: UIViewController())
    }
}


struct LoginRoute: Route {
    let name: String = "login"
    let navigationController: UINavigationController? = nil
    let viewController: UIViewController

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    static func make() -> Route {
        return LoginRoute(viewController: LoginViewController())
    }
}


// MARK: - Dummy view controllers

class ContainerViewController: UIViewController {}

class LoginViewController: UIViewController {}
