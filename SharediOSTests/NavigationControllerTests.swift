//
//  NavigationControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 11/02/23.
//

import XCTest
import SharediOS

final class NavigationControllerTests: XCTestCase {
    func test_init_viewContollerList_deliversRootViewController() {
        let rootViewController = UIViewController()
        let navItem = NavigationController.RootNavigationItem(title: nil, leftButton: (nil, false), rightButton: (nil, false))
        let sut = NavigationController(rootViewController: rootViewController, navItem: navItem)
        
        XCTAssertEqual(sut.viewControllers, [rootViewController])
    }
    
    func test_init_topViewControllerTitle() {
        let title = "Home"
        let navItem = NavigationController.RootNavigationItem(title: title, leftButton: ("", true), rightButton: ("", true))
        let sut = NavigationController(rootViewController: UIViewController(), navItem: navItem)
        
        XCTAssertEqual(sut.rootNavigationItem?.title, title, "Expected title to be \(title)")
        
        let navItem1 = NavigationController.RootNavigationItem(title: nil, leftButton: ("", true), rightButton: ("", true))
        let sut1 = NavigationController(rootViewController: UIViewController(), navItem: navItem1)
        
        XCTAssertNil(sut1.rootNavigationItem?.title, "Expected no title")
    }
    
    func test_init_topViewControllerBarButtonTitle() {
        let leftButton: (title: String, isEnabled: Bool) = ("Cancel", true)
        let rightButton: (title: String, isEnabled: Bool) = ("Done", true)
        let navItem = NavigationController.RootNavigationItem(title: "", leftButton: leftButton, rightButton: rightButton)
        
        let sut = NavigationController(rootViewController: UIViewController(), navItem: navItem)
        
        XCTAssertEqual(sut.leftBarButtonItem?.title, leftButton.title, "Expected left button title to be \(leftButton.title)")
        XCTAssertEqual(sut.rightBarButtonItem?.title, rightButton.title, "Expected right button title to be \(rightButton.title)")
    }
    
    func test_init_topViewControllerBarButtonisEnabled() {
        let leftButton: (title: String, isEnabled: Bool) = ("", true)
        let rightButton: (title: String, isEnabled: Bool) = ("", true)
        let navItem = NavigationController.RootNavigationItem(title: "", leftButton: leftButton, rightButton: rightButton)
        
        let sut = NavigationController(rootViewController: UIViewController(), navItem: navItem)
        
        XCTAssertEqual(sut.leftBarButtonItem?.isEnabled, leftButton.isEnabled, "Expected left button isEnabled to be \(leftButton.isEnabled)")
        XCTAssertEqual(sut.rightBarButtonItem?.isEnabled, rightButton.isEnabled, "Expected right button isEnabled to be \(rightButton.isEnabled)")
        
        let leftButton1: (title: String, isEnabled: Bool) = ("", false)
        let rightButton1: (title: String, isEnabled: Bool) = ("", false)
        let navItem1 = NavigationController.RootNavigationItem(title: "", leftButton: leftButton1, rightButton: rightButton1)
        
        let sut1 = NavigationController(rootViewController: UIViewController(), navItem: navItem1)
        
        XCTAssertEqual(sut1.leftBarButtonItem?.isEnabled, leftButton1.isEnabled, "Expected left button isEnabled to be \(leftButton1.isEnabled)")
        XCTAssertEqual(sut1.rightBarButtonItem?.isEnabled, rightButton1.isEnabled, "Expected right button isEnabled to be \(rightButton1.isEnabled)")
    }
    
}

private extension NavigationController {
    var leftBarButtonItem: UIBarButtonItem? {
        rootNavigationItem?.leftBarButtonItem
    }
    
    var rightBarButtonItem: UIBarButtonItem? {
        rootNavigationItem?.rightBarButtonItem
    }
    
    var rootNavigationItem: UINavigationItem? {
        topViewController?.navigationItem
    }
}
