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
                
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route)))
                
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
                
                expect(viewControllers.count).to(equal(1))
                
                
            }
            it("Should push both parent and child viewcontroller on the stack"){
                // Arrange
                let route = ApplicationRouter.RouteNames.container_scanner.rawValue
                let mainRouter = MainRouter.get()
                
                // Act
                
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route)))
                
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
      
                expect(viewControllers.count).to(equal(1))
            
                
            }
            it("Should push two viewControllers on the stack"){
                // Arrange
                let route1 = ApplicationRouter.RouteNames.container.rawValue
                let route2 = ApplicationRouter.RouteNames.login.rawValue
                let mainRouter = MainRouter.get()
                
                // Act
                
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route1)))
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route2)))
                
                
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
                expect(viewControllers.count).to(equal(2))
                expect(viewControllers.last is LoginViewController).to(equal(true))
                expect(viewControllers.first is ContainerViewController).to(equal(true))
                
            }
            it("Should push the same viewController twice"){
                // Arrange
                let route = ApplicationRouter.RouteNames.container_scanner.rawValue
                let mainRouter = MainRouter.get()
                
                // Act
                
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route)))
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route)))
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
                
                expect(viewControllers.count).to(equal(2))
            }
            
            it("Should dismiss all previous viewControllers"){
                // Arrange
                let route1 = ApplicationRouter.RouteNames.container.rawValue
                let route2 = ApplicationRouter.RouteNames.login.rawValue
                let mainRouter = MainRouter.get()
                
                // Act
                
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route1)))
                store.dispatch(RouteChangeAction(route: RouteChangeAction.Payload(route: route2, dismissPrevious: true)))
                // Assert
                let viewControllers = mainRouter.mainNavigationController.viewControllers
                
                expect(viewControllers.count).to(equal(1))
                expect(viewControllers.first is LoginViewController).to(equal(true))
            }
        }
    }
    
}


