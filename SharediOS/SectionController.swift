//
//  SectionController.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import UIKit

public typealias CellController = UITableViewDataSource & UITableViewDelegate

public struct SectionController {
    public let headerController: HeaderController?
    public let controllers: [CellController]
    
    public init(headerController: HeaderController?, controllers: [CellController]) {
        self.headerController = headerController
        self.controllers = controllers
    }
}

public struct HeaderController {
    public let headerView: UIView
    
    public init(headerView: UIView) {
        self.headerView = headerView
    }
}
