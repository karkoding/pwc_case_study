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
        let navItem = makeRootNavigationItem()
        let sut = makeSUT(rootViewController: rootViewController, navItem: navItem)
        
        XCTAssertEqual(sut.viewControllers, [rootViewController])
    }
    
    func test_init_topViewControllerTitle() {
        let title = "Home"
        let navItem = makeRootNavigationItem(title: title)
        let sut = makeSUT(navItem: navItem)
        
        XCTAssertEqual(sut.rootNavigationItem?.title, title, "Expected title to be \(title)")
        
        let navItem1 = makeRootNavigationItem(title: nil)
        let sut1 = NavigationController(rootViewController: UIViewController(), navItem: navItem1)
        
        XCTAssertNil(sut1.rootNavigationItem?.title, "Expected no title")
    }
    
    func test_init_topViewControllerBarButtons() {
        let navItem = makeRootNavigationItem(leftButton: nil, rightButton: nil)
        
        let sut = makeSUT(navItem: navItem)
        
        XCTAssertNil(sut.leftBarButtonItem, "Expected no left button")
        XCTAssertNil(sut.rightBarButtonItem, "Expected no right button")
    }
    
    func test_init_topViewControllerBarButtonTitle() {
        let leftButton: (title: String, isEnabled: Bool) = ("Cancel", true)
        let rightButton: (title: String, isEnabled: Bool) = ("Done", true)
        let navItem = makeRootNavigationItem(leftButton: leftButton, rightButton: rightButton)
        
        let sut = makeSUT(navItem: navItem)
        
        XCTAssertEqual(sut.leftBarButtonItem?.title, leftButton.title, "Expected left button title to be \(leftButton.title)")
        XCTAssertEqual(sut.rightBarButtonItem?.title, rightButton.title, "Expected right button title to be \(rightButton.title)")
        
        
        let sut1 = makeSUT(navItem: makeRootNavigationItem(leftButton: ("", true), rightButton: ("", true)))
        
        XCTAssertEqual(sut1.leftBarButtonItem?.title, "", "Expected left button title to be empty")
        XCTAssertEqual(sut1.rightBarButtonItem?.title, "", "Expected right button title to be empty")
    }
    
    func test_init_topViewControllerBarButtonisEnabled() {
        let navItem = makeRootNavigationItem(leftButton: ("", true), rightButton: ("", true))
        
        let sut = makeSUT(navItem: navItem)
        
        XCTAssertTrue(sut.leftBarButtonItem!.isEnabled, "Expected left button to be enabled")
        XCTAssertTrue(sut.rightBarButtonItem!.isEnabled, "Expected right button to be enabled")
        
        let navItem1 = makeRootNavigationItem(leftButton: ("", false), rightButton: ("", false))
        
        let sut1 = makeSUT(navItem: navItem1)
        
        XCTAssertFalse(sut1.leftBarButtonItem!.isEnabled, "Expected left button to be disabled")
        XCTAssertFalse(sut1.rightBarButtonItem!.isEnabled, "Expected right button to be disabled")
    }
    
    private func makeSUT(
        rootViewController: UIViewController = UIViewController(),
        navItem: NavigationController.RootNavigationItem,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> NavigationController {
        let sut = NavigationController(rootViewController: rootViewController, navItem: navItem)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    func makeRootNavigationItem(title: String? = nil, leftButton: (title: String, isEnabled: Bool)? = nil, rightButton: (title: String, isEnabled: Bool)? = nil) -> NavigationController.RootNavigationItem {
        NavigationController.RootNavigationItem(title: title, leftButton: leftButton, rightButton: rightButton)
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
