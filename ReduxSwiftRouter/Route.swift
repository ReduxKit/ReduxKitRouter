//
//  Routes.swift
//  ReduxSwiftRouter
//
//  Created by Aleksander Herforth Rendtslev on 23/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

import Foundation
import UIKit

public protocol Router{
    var mainNavigationController: UINavigationController {get}
    var activeRoute: Route {get set}
   
    func getRoute(route: String) throws -> Route
}


public protocol Route{
    var name: String {get}
    
    var navigationController: UINavigationController? {get}
    var viewController: UIViewController {get}
    var hasChildren: Bool {get}
    
    // Factory for creating a new UIViewController
    
    static func make() -> Route
}

public extension Route{
    public var hasChildren: Bool { return navigationController != nil ? true : false }
}

public typealias RouteDictionary = [String: Route.Type]
