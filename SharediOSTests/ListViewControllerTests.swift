//
//  ListiOSTests.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerTests: XCTestCase {
    func test_viewDidLoad_messagesOnViewDidLoadOnce() {
        let sut = ListViewController()
        
        var callCount = 0
        sut.onViewDidLoad = {  callCount += 1 }
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_updateTableModel_doesNotRenderOnEmptyList() {
        let sut = ListViewController()
        
        sut.updateTableModel(sectionController: [])
        
        XCTAssertEqual(sut.numberOfItemsRendered(), 0)
    }

}

private extension ListViewController {
    func numberOfItemsRendered() -> Int {
        let dataSource = tableView.dataSource!
        let itemsCount = dataSource.numberOfSections?(in: tableView)
        return itemsCount ?? .zero
    }
}
