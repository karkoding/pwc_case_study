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
        sut.onViewDidLoad = { callCount += 1 }
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_viewDidLoad_messagesConfigureTableViewOnce() {
        let sut = makeSUT()
        
        var callCount = 0
        sut.configureTableView = { _ in callCount += 1 }
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_updateTableModel_doesNotRenderSectionOrItemstOnEmptyList() {
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
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any items")
    }
    
    func test_updateTableModel_renderSectionAndItemsForAnItemWithSectionAndNonEmptyList() {
        let sut = makeSUT()
        let givenCell = UITableViewCell()
        let givenView = UIView()
        let cellController = CellControllerStub(tableViewCell: givenCell)
        let headerController = HeaderControllerStub(view: givenView)
        let item1 = SectionController(headerController: headerController, controllers: [cellController])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1, "Expected to have a one section")
        XCTAssertEqual(sut.viewForHeaderIn(section: 0), givenView, "Expected to render given view")
        XCTAssertEqual(sut.item(at: 0, in: 0), givenCell, "Expected to render the given cell")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
    }
    
    func test_updateTableModel_rendersItemsWithoutSectionForAnItemWithNoSectionAndNonEmptyList() {
        let sut = makeSUT()
        let item1 = SectionController(headerController: nil, controllers: [CellControllerStub()])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertNil(sut.viewForHeaderIn(section: 0), "Expected not to render a header view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
    }
    
    func test_updateTableModel_rendersSectionWithoutItemsForAnItemWithSectionAndEmptyList() {
        let sut = makeSUT()
        let givenView = UIView()
        let headerController = HeaderControllerStub(view: givenView)
        let item1 = SectionController(headerController: headerController, controllers: [])
        
        sut.updateTableModel(sectionController: [item1])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertEqual(sut.viewForHeaderIn(section: 0), givenView, "Expected to render given view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any item")
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        ListViewController()
    }
    
    private final class CellControllerStub: NSObject, CellController {
        private let tableViewCell: UITableViewCell
        
        init(tableViewCell: UITableViewCell = UITableViewCell()) {
            self.tableViewCell = tableViewCell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { tableViewCell }
    }
    
    private final class HeaderControllerStub: HeaderController {
        private let view: UIView
        
        init(view: UIView) {
            self.view = view
        }
        
        func makeHeaderView() -> UIView { view }
    }

}

private extension ListViewController {
    func numberOfSections() -> Int {
        let dataSource = tableView.dataSource!
        return dataSource.numberOfSections?(in: tableView) ?? .zero
    }
    
    func numberOfRenderedItemsIn(section: Int) -> Int {
        let dataSource = tableView.dataSource!
        return dataSource.tableView(tableView, numberOfRowsInSection: section)
    }
    
    func viewForHeaderIn(section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func item(at row: Int, in section: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource!
        let indexPath = IndexPath(row: row, section: section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
