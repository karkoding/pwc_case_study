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
        
        if let leftButton = navItem.leftButton {
            rootNavigationItem?.leftBarButtonItem = UIBarButtonItem(
                title: navItem.leftButton?.title,
                image: nil,
                target: self,
                action: #selector(handleLeftButtonTap)
            )
            
            rootNavigationItem?.leftBarButtonItem?.isEnabled = leftButton.isEnabled
        }
        
        if let rightButton = navItem.rightButton {
            rootNavigationItem?.rightBarButtonItem = UIBarButtonItem(
                title: navItem.rightButton?.title,
                image: nil,
                target: self,
                action: #selector(handleRightButtonTap)
            )
            
            rootNavigationItem?.rightBarButtonItem?.isEnabled = rightButton.isEnabled
        }
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
