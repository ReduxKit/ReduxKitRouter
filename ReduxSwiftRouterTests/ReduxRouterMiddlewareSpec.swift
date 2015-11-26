//
//  RouteSpec.swift
//  ReduxSwiftRouter
//
//  Created by Aleksander Herforth Rendtslev on 24/11/15.
//  Copyright © 2015 Kare Media. All rights reserved.
//


import Quick
import Nimble
import RxSwift
import SwiftRedux
@testable import ReduxSwiftRouter


class ReduxRouterMiddlewareSpec: QuickSpec {
    
    
    override func spec(){
        
        var defaultState: AppState!
        var store: TypedStore<AppState>!
        
        describe("ReduxRouterMiddlewareSpec"){
            
            beforeEach{
                // Arrange
                store = createTypedStore([
                    reduxRouter(ApplicationRouter())
                    ])(createStore)(applicationReducer, nil)
                defaultState = store.getState()
            }
            
            
            it("Should push only one viewController on the stack"){
                // Arrange
                let route = ApplicationRouter.RouteNames.container.rawValue
                let mainRouter = MainRouter.get()
                
                // Act
                
                //store.dispatch(RouteChangeAction(route: route))
                
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
                expect(1).to(equal(1))
                expect(viewControllers.count).to(equal(1))
                
                
            }
            it("Should push both parent and child viewcontroller on the stack"){
                // Arrange
                let route = ApplicationRouter.RouteNames.container_scanner.rawValue
                let mainRouter = MainRouter.get()
                
                // Act
                
                store.dispatch(RouteChangeAction(route: route))
                
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
                expect(1).to(equal(1))
                expect(viewControllers.count).to(equal(3))
                
                
            }
            it("Should not push the same route on stack twice"){
                // Arrange
                let route = ApplicationRouter.RouteNames.container_scanner.rawValue
                let mainRouter = MainRouter.get()
                
                // Act
                
                store.dispatch(RouteChangeAction(route: route))
                store.dispatch(RouteChangeAction(route: route))
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
                expect(1).to(equal(1))
                expect(viewControllers.count).to(equal(3))
                
                
            }
        }
    }
    
}


