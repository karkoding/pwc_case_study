//
//  SectionCellController.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 17/02/23.
//

import UIKit

public final class SectionCellController: NSObject {
    public private(set) var cellControllers: [CellController]
    public private(set) var headerView: UIView?
    public private(set) var footerView: UIView?
    
    public init(cellControllers: [CellController], headerView: UIView?, footerView: UIView?) {
        self.cellControllers = cellControllers
        self.headerView = headerView
        self.footerView = footerView
    }
}

extension SectionCellController: CellController {
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { cellControllers.count }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellControllers[indexPath.item].tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellControllers[indexPath.item].tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        cellControllers[indexPath.item].tableView?(tableView, didDeselectRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { headerView }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { footerView }
}
