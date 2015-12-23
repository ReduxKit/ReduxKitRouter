//
//  RouteViewController.swift
//  ReduxKitRouter
//
//  Created by Aleksander Herforth Rendtslev on 27/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

/**

 A viewController protocol that has a type property This property is used to
 ensure that no more than one type of a controller is added to the stack more
 than once

 */
public protocol RouteViewController {
    var id: String { get set }
}
