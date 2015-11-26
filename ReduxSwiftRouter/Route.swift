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
    var routes: RouteDictionary {get set}
   
    func getRoute(route: String) throws -> Route
}

extension Router{
    public func getRoute(routeName: String) throws -> Route{
        
        /// filter routes for the given routeName
        let results = self.routes.filter{ route in
            if(route.0 == routeName){
                return true
            }
            return false
        }
        
        ///  Check whether any matching routes were found
        guard let result = results.first else{
            throw RouteErrors.RouteNotFound
        }
        
        /**
        *  Return the route
        */
        return result.1
    }
}

public protocol Route{
    var name: String {get}
    var viewController: () -> UIViewController {get}
    var navigationController: UINavigationController? {get}
    var hasChildren: Bool {get}
}

public extension Route{
    public var hasChildren: Bool { return navigationController != nil ? true : false }
}

public typealias RouteDictionary = [String: Route]
