//
//  SectionController.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import UIKit

public typealias CellController = UITableViewDataSource & UITableViewDelegate

public protocol HeaderController {
    func makeHeaderView() -> UIView
}

public struct SectionController {
    public let headerController: HeaderController?
    public let cellControllers: [CellController]
    
    public init(headerController: HeaderController?, cellControllers: [CellController]) {
        self.headerController = headerController
        self.cellControllers = cellControllers
    }
}
