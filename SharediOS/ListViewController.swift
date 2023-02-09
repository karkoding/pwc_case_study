//
//  ListViewController.swift
//  ListiOS
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

public final class ListViewController: UITableViewController {
    
    private var tableModel = [SectionController]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    public var onViewDidLoad: (() -> Void)?
    public var configureTableView: ((UITableView) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        onViewDidLoad?()
        
        configureTableView?(tableView)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel[section].controllers.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionController = tableModel[indexPath.section]
        let cellController = sectionController.controllers[indexPath.row]
        let cell = cellController.tableView(tableView, cellForRowAt: indexPath)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionController = tableModel[indexPath.section]
        let cellController = sectionController.controllers[indexPath.row]
        cellController.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let sectionController = tableModel[indexPath.section]
        let cellController = sectionController.controllers[indexPath.row]
        cellController.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableModel[section].headerController?.headerView
    }
    
    public func updateTableModel(sectionController: [SectionController]) {
        tableModel = sectionController
    }
}
