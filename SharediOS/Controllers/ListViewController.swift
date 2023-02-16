//
//  ListViewController.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import UIKit

public final class ListViewController: UITableViewController {
    private var tableModel = [CellController]() {
        didSet { tableView.reloadData() }
    }
    
    public var onRequestToLoad: (() -> Void)?
    public var configureListView: ((UITableView) -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        onRequestToLoad?()
        configure()
        configureListView?(tableView)
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        tableModel.reduce(0) { partialResult, cellController in
            partialResult + (cellController.numberOfSections?(in: tableView) ?? 1)
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         cellController(forSection: section, in: tableView).tableView(tableView, numberOfRowsInSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forSection: indexPath.section, in: tableView).tableView(tableView, cellForRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableModel[indexPath.section].tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableModel[indexPath.section].tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    public override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        cellController(forSection: section, in: tableView).tableView?(tableView, viewForHeaderInSection: section)
    }
    
    public override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        cellController(forSection: section, in: tableView).tableView?(tableView, viewForFooterInSection: section)
    }
    
    public func display(cellControllers: [CellController]) {
        tableModel = cellControllers
    }
    
    private func configure() {
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
    }
    
    private func cellController(forSection section: Int, in tableView: UITableView) -> CellController {
        var sectionCount = 0
        for cellController in tableModel {
            sectionCount += cellController.numberOfSections?(in: tableView) ?? 1
            if section < sectionCount {
                return cellController
            }
        }
        
        fatalError("CellController Not Found for section \(section)")
    }
}
