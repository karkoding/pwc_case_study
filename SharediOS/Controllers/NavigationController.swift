//
//  NavigationController.swift
//  ListiOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import UIKit

public class NavigationController: UINavigationController {
    public struct RootNavigationItem {
        internal let title: String?
        internal let leftButton: (title: String, isEnabled: Bool)?
        internal let rightButton: (title: String, isEnabled: Bool)?

        public init(
            title: String?,
            leftButton: (title: String, isEnabled: Bool)?,
            rightButton: (title: String, isEnabled: Bool)?
        ) {
            self.title = title
            self.leftButton = leftButton
            self.rightButton = rightButton
        }
    }

    private let navItem: RootNavigationItem
    
    private var rootNavigationItem: UINavigationItem? {
        topViewController?.navigationItem
    }
    
    public var rightButtonTapped: (() -> Void)?
    public var leftButtonTapped: (() -> Void)?
    
    public init(rootViewController: UIViewController, navItem: RootNavigationItem) {
        self.navItem = navItem
        super.init(rootViewController: rootViewController)
        
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        rootNavigationItem?.title = navItem.title
        rootNavigationItem?.leftBarButtonItem = UIBarButtonItem(
            title: navItem.leftButton?.title,
            image: nil,
            target: self,
            action: #selector(handleLeftButtonTap)
        )
        
        topViewController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: navItem.rightButton?.title,
            image: nil,
            target: self,
            action: #selector(handleRightButtonTap)
        )
        
        rootNavigationItem?.leftBarButtonItem?.isEnabled = navItem.leftButton?.isEnabled ?? true
        rootNavigationItem?.rightBarButtonItem?.isEnabled = navItem.rightButton?.isEnabled ?? true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleLeftButtonTap() {
        leftButtonTapped?()
        dismiss(animated: true)
    }
    
    @objc private func handleRightButtonTap() {
        rightButtonTapped?()
    }
    
    public func updateRightButton(isEnabled: Bool) {
        rootNavigationItem?.rightBarButtonItem?.isEnabled = isEnabled
    }
}
