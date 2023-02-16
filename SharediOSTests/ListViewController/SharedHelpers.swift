//
//  SharedHelpers.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import UIKit
import SharediOS

public extension ListViewController {
    var isSeparatorLineVisible: Bool {
        !(tableView.separatorStyle == .none)
    }
    
    var sectionHeaderTopPadding: CGFloat {
        tableView.sectionHeaderTopPadding
    }
    
    var numberOfSections: Int {
        tableView.numberOfSections
    }
    
    func numberOfRenderedItemsIn(section: Int) -> Int {
        tableView.numberOfRows(inSection: section)
    }
    
    func itemAt(section: Int, row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource!
        let indexPath = IndexPath(row: row, section: section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func headerView(for section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func footerView(for section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    func didSelectItemAt(section: Int, row: Int) {
        let delegate = tableView.delegate
        let indexPath =  IndexPath(row: row, section: section)
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func didDeSelectItemAt(section: Int, row: Int) {
        let delegate = tableView.delegate
        let indexPath =  IndexPath(row: row, section: section)
        delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
    }
}
