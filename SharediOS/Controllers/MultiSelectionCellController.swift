//
//  MultiSelectionCellController.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 18/02/23.
//

import UIKit

// THIS IS NOT FULLY IMPLEMENTED FOR MULTISELECTION. WIP

public final class MultiSelectionCellController: NSObject {
    public private(set) var cellControllers: [CellController]
    
    public init(cellControllers: [CellController]) {
        self.cellControllers = cellControllers
    }
}

extension MultiSelectionCellController: CellController {
    public func numberOfSections(in tableView: UITableView) -> Int {
        cellControllers.reduce(0) { $0 + ($1.numberOfSections?(in: tableView) ?? 1) }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellController(for: section, tableView: tableView).tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(for: indexPath.section, tableView: tableView).tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        cellController(for: section, tableView: tableView).tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func cellController(for section: Int, tableView: UITableView) -> CellController {
        var sectionCount = 0
        for controller in cellControllers {
            sectionCount += controller.numberOfSections?(in: tableView) ?? 1
            if section < sectionCount {
                return controller
            }
        }
        
        fatalError("Trying to access non existing cell controller for section \(section)")
    }
}
