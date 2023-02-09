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
    
    func test_updateTableModel_rendersOneItemOnListWithOneItem() {
        let sut = ListViewController()
        let item1 = SectionController(headerController: nil, controllers: [])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfItemsRendered(), 1)
    }
    
    func test_updateTableModel_rendersMultipleItemsOnListWithMultipleItems() {
        let sut = ListViewController()
        let item1 = SectionController(headerController: nil, controllers: [])
        let item2 = SectionController(headerController: nil, controllers: [])
        
        sut.updateTableModel(sectionController: [item1, item2])
        
        XCTAssertEqual(sut.numberOfItemsRendered(), 2)
    }

}

private extension ListViewController {
    func numberOfItemsRendered() -> Int {
        let dataSource = tableView.dataSource!
        let itemsCount = dataSource.numberOfSections?(in: tableView)
        return itemsCount ?? .zero
    }
}
