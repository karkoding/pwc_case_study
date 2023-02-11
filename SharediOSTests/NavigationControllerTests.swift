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
        let sut = makeSUT(rootViewController: rootViewController, navItem: makeRootNavigationItem())
        
        XCTAssertEqual(sut.viewControllers, [rootViewController])
    }
    
    func test_init_rootViewControllerTitle() {
        let title = "Home"
        let sut = makeSUT(navItem: makeRootNavigationItem(title: title))
        
        XCTAssertEqual(sut.navTitle, title, "Expected title to be \(title)")
        
        let sut1 = makeSUT(navItem: makeRootNavigationItem(title: nil))
        
        XCTAssertNil(sut1.navTitle, "Expected no title")
    }
    
    func test_init_rootViewControllerBarButtons() {
        let sut = makeSUT(navItem: makeRootNavigationItem(leftButton: nil, rightButton: nil))
        
        XCTAssertNil(sut.leftBarButtonItem, "Expected no left button")
        XCTAssertNil(sut.rightBarButtonItem, "Expected no right button")
    }
    
    func test_init_rootViewControllerBarButtonTitle() {
        let leftButton: (title: String, isEnabled: Bool) = ("Cancel", true)
        let rightButton: (title: String, isEnabled: Bool) = ("Done", true)
        
        let sut = makeSUT(navItem: makeRootNavigationItem(leftButton: leftButton, rightButton: rightButton))
        
        XCTAssertEqual(sut.leftBarButtonItem?.title, leftButton.title, "Expected left button title to be \(leftButton.title)")
        XCTAssertEqual(sut.rightBarButtonItem?.title, rightButton.title, "Expected right button title to be \(rightButton.title)")
        
        
        let sut1 = makeSUT(navItem: makeRootNavigationItem(leftButton: ("", true), rightButton: ("", true)))
        
        XCTAssertEqual(sut1.leftBarButtonItem?.title, "", "Expected left button title to be empty")
        XCTAssertEqual(sut1.rightBarButtonItem?.title, "", "Expected right button title to be empty")
    }
    
    func test_init_rootViewControllerBarButtonisEnabled() {
        let sut = makeSUT(navItem: makeRootNavigationItem(leftButton: ("", true), rightButton: ("", true)))
    
        XCTAssertEqual(sut.leftBarButtonItem?.isEnabled, true, "Expected left button to be enabled")
        XCTAssertEqual(sut.rightBarButtonItem?.isEnabled, true, "Expected right button to be enabled")
    
        let sut1 = makeSUT(navItem: makeRootNavigationItem(leftButton: ("", false), rightButton: ("", false)))
        
        XCTAssertEqual(sut1.leftBarButtonItem?.isEnabled, false, "Expected left button to be disabled")
        XCTAssertEqual(sut1.rightBarButtonItem?.isEnabled, false, "Expected right button to be disabled")
    }
    
    func test_didTapLeftButton_messagesLeftButtonTappedOnce() {
        var sut: NavigationController? = makeSUT(navItem: makeRootNavigationItem(leftButton: ("Cancel", true)))
        
        var callCount = 0
        sut?.leftButtonTapped = {
            callCount += 1
        }
        
        sut?.perform(sut?.leftBarButtonItem?.action)
        
        XCTAssertEqual(callCount, 1)
        
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut)
        }
    }
    
    func test_didTapRightButton_messagesRightButtonTappedOnce() {
        let sut = makeSUT(navItem: makeRootNavigationItem(rightButton: ("Done", true)))
        
        var callCount = 0
        sut.rightButtonTapped = {
            callCount += 1
        }
        
        sut.perform(sut.rightBarButtonItem?.action)
        
        XCTAssertEqual(callCount, 1)
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
    
    var navTitle: String? {
        rootNavigationItem?.title
    }
    
    var rootNavigationItem: UINavigationItem? {
        topViewController?.navigationItem
    }
}
