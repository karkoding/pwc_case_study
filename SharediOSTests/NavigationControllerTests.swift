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
        let rootViewController = UIViewController()
        let title = "Home"
        let navItem = NavigationController.RootNavigationItem(title: title, leftButton: ("", true), rightButton: ("", true))
        
        let sut = NavigationController(rootViewController: rootViewController, navItem: navItem)
        
        XCTAssertEqual(sut.topViewController?.navigationItem.title, title, "Expected title to be \(title)")
    }
    
    func test_init_topViewControllerBarButtons() {
        let rootViewController = UIViewController()
        let leftButton: (title: String, isEnabled: Bool) = ("Cancel", true)
        let rightButton: (title: String, isEnabled: Bool) = ("Done", true)
        let navItem = NavigationController.RootNavigationItem(title: "", leftButton: leftButton, rightButton: rightButton)
        
        let sut = NavigationController(rootViewController: rootViewController, navItem: navItem)
        
        XCTAssertEqual(sut.topViewController?.navigationItem.leftBarButtonItem?.title, leftButton.title, "Expected left button title to be \(leftButton.title)")
        XCTAssertEqual(sut.topViewController?.navigationItem.leftBarButtonItem?.isEnabled, leftButton.isEnabled, "Expected left button isEnabled to be \(leftButton.isEnabled)")
        
        XCTAssertEqual(sut.topViewController?.navigationItem.rightBarButtonItem?.title, rightButton.title, "Expected right button title to be \(rightButton.title)")
        XCTAssertEqual(sut.topViewController?.navigationItem.rightBarButtonItem?.isEnabled, rightButton.isEnabled, "Expected right button isEnabled to be \(rightButton.isEnabled)")
    }
}
