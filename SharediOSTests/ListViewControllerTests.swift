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
        let sut = makeSUT()
        
        var callCount = 0
        sut.onViewDidLoad = {  callCount += 1 }
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_updateTableModel_doesNotRenderListOnEmptyList() {
        let sut = makeSUT()
        
        sut.updateTableModel(sectionController: [])
        
        XCTAssertEqual(sut.numberOfSections(), 0)
    }
    
    func test_updateTableModel_doesNotRenderSectionOrItemsForAnItemWithNoSectionAndEmptyList() {
        let sut = makeSUT()
        let item1 = SectionController(headerController: nil, controllers: [])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1, "Expected to have a one section")
        XCTAssertNil(sut.viewForHeaderIn(section: 0), "Expected not to render a header view")
        XCTAssertEqual(sut.numberOfItemsRenderedIn(section: 0), 0, "Expected not to render any items")
    }
    
    func test_updateTableModel_renderSectionAndItemsForAnItemWithSectionAndNonEmptyList() {
        let sut = makeSUT()
        let item1 = SectionController(headerController: FakeHeaderController(), controllers: [FakeCellController()])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1, "Expected to have a one section")
        XCTAssertNotNil(sut.viewForHeaderIn(section: 0), "Expected to render a header view")
        XCTAssertEqual(sut.numberOfItemsRenderedIn(section: 0), 1, "Expected to render an item")
    }
    
    func test_updateTableModel_rendersOneSectionWithOneItem() {
        let sut = makeSUT()
        let item1 = SectionController(headerController: nil, controllers: [FakeCellController()])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertEqual(sut.numberOfItemsRenderedIn(section: 0), 1)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        ListViewController()
    }
    
    private final class FakeCellController: NSObject, CellController {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
    }
    
    private final class FakeHeaderController: HeaderController {
        func makeHeaderView() -> UIView { UIView() }
    }

}

private extension ListViewController {
    func numberOfSections() -> Int {
        let dataSource = tableView.dataSource!
        return dataSource.numberOfSections?(in: tableView) ?? .zero
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
