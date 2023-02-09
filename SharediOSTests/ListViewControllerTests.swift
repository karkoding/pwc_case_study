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
    
    func test_updateTableModel_doesNotRenderListOnEmptyList() {
        let sut = ListViewController()
        
        sut.updateTableModel(sectionController: [])
        
        XCTAssertEqual(sut.numberOfSections(), 0)
    }
    
    func test_updateTableModel_doesNotRenderSectionOrItemsForAnItemWithNoSectionAndEmptyList() {
        let sut = ListViewController()
        let item1 = SectionController(headerController: nil, controllers: [])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertNil(sut.viewForHeaderIn(section: 0))
        XCTAssertEqual(sut.numberOfItemsRenderedIn(section: 0), 0)
    }
    
    func test_updateTableModel_rendersOneSectionWithOneItem() {
        let sut = ListViewController()
        let item1 = SectionController(headerController: nil, controllers: [FakeCellController()])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertEqual(sut.numberOfItemsRenderedIn(section: 0), 1)
    }
    
    class FakeCellController: NSObject, CellController {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
    }

}

private extension ListViewController {
    func numberOfSections() -> Int {
        let dataSource = tableView.dataSource!
        let itemsCount = dataSource.numberOfSections?(in: tableView)
        return itemsCount ?? .zero
    }
    
    func numberOfItemsRenderedIn(section: Int) -> Int {
        let dataSource = tableView.dataSource!
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func viewForHeaderIn(section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
}
