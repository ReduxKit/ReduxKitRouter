//
//  RouteErrors.swift
//  ReduxKitRouter
//
//  Created by Aleksander Herforth Rendtslev on 26/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//

public enum RouteErrors: ErrorType {
    case SubRoutesOnNonNavigationController
    case RouteNotFound
    case AppStateNotImplementingRoutableState
}
