//
//  ListViewController.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import UIKit

public final class ListViewController: UITableViewController {
    private var tableModel = [SectionController]() {
        didSet { tableView.reloadData() }
    }
    
    public var onRefresh: (() -> Void)?
    public var configureTableView: ((UITableView) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        onRefresh?()
        
        configureTableView?(tableView)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel[section].cellControllers.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionController = tableModel[indexPath.section]
        let cellController = sectionController.cellControllers[indexPath.row]
        return cellController.tableView(tableView, cellForRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionController = tableModel[indexPath.section]
        let cellController = sectionController.cellControllers[indexPath.row]
        cellController.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let sectionController = tableModel[indexPath.section]
        let cellController = sectionController.cellControllers[indexPath.row]
        cellController.tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableModel[section].headerController?.makeHeaderView()
    }
    
    public func display(sectionController: [SectionController]) {
        tableModel = sectionController
    }
}
