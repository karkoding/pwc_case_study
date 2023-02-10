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
        
        XCTAssertEqual(sut.numberOfRenderedSection(), 0)
    }
    
    func test_updateTableModel_doesNotRenderSectionOrItems_ForSectionItemWithNoSectionAndEmptyList() {
        let sut = makeSUT()
        let section1 = SectionController(headerController: nil, controllers: [])
        
        sut.updateTableModel(sectionController: [section1])
        
        XCTAssertEqual(sut.numberOfSections(), 1, "Expected to have a one section")
        XCTAssertNil(sut.viewForHeaderIn(section: 0), "Expected not to render a header view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any items")
    }
    
    func test_updateTableModel_renderSectionAndItems_ForSectionItemWithSectionAndNonEmptyList() {
        let sut = makeSUT()
        let givenCell = UITableViewCell()
        let givenView = UIView()
        let cellController = CellControllerStub(tableViewCell: givenCell)
        let headerController = HeaderControllerStub(view: givenView)
        let section1 = SectionController(headerController: headerController, controllers: [cellController])
        
        sut.updateTableModel(sectionController: [section1])
        
        XCTAssertEqual(sut.numberOfSections(), 1, "Expected to have a one section")
        XCTAssertEqual(sut.viewForHeaderIn(section: 0), givenView, "Expected to render given view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.item(at: 0, in: 0), givenCell, "Expected to render the given cell")
    }
    
    func test_updateTableModel_rendersItemsWithoutSection_ForSectionItemWithNoSectionAndNonEmptyList() {
        let sut = makeSUT()
        let givenCell = UITableViewCell()
        let cellController = CellControllerStub(tableViewCell: givenCell)
        let section1 = SectionController(headerController: nil, controllers: [cellController])
        
        sut.updateTableModel(sectionController: [section1])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertNil(sut.viewForHeaderIn(section: 0), "Expected not to render a header view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.item(at: 0, in: 0), givenCell, "Expected to render the given cell")
    }
    
    func test_updateTableModel_rendersSectionWithoutItems_ForSectionItemWithSectionAndEmptyList() {
        let sut = makeSUT()
        let givenView = UIView()
        let headerController = HeaderControllerStub(view: givenView)
        let section1 = SectionController(headerController: headerController, controllers: [])
        
        sut.updateTableModel(sectionController: [section1])
        
        XCTAssertEqual(sut.numberOfSections(), 1)
        XCTAssertEqual(sut.viewForHeaderIn(section: 0), givenView, "Expected to render given view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any item")
    }
    
    func test_updateTableModel_rendersMultipleItemsInSection() {
        let sut = makeSUT()
        let givenCell1 = UITableViewCell()
        let givenCell2 = UITableViewCell()
        let cellController1 = CellControllerStub(tableViewCell: givenCell1)
        let cellController2 = CellControllerStub(tableViewCell: givenCell2)
        let section1 = SectionController(headerController: nil, controllers: [cellController1, cellController2])
        
        sut.updateTableModel(sectionController: [section1])
        
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 2)
        XCTAssertEqual(sut.item(at: 0, in: 0), givenCell1)
        XCTAssertEqual(sut.item(at: 1, in: 0), givenCell2)
    }
    
    func test_updateTableModel_rendersLatestItem() {
        let sut = makeSUT()
        let givenCell1 = UITableViewCell()
        let givenCell2 = UITableViewCell()
        let cellController1 = CellControllerStub(tableViewCell: givenCell1)
        let cellController2 = CellControllerStub(tableViewCell: givenCell2)

        let section = SectionController(headerController: nil, controllers: [cellController1])
        
        sut.updateTableModel(sectionController: [section])
        
        XCTAssertEqual(sut.numberOfRenderedItemsInTableView(section: 0), 1, "Expected to render one item")

        let updatedSection = SectionController(headerController: nil, controllers: [cellController1, cellController2])

        sut.updateTableModel(sectionController: [updatedSection])

        XCTAssertEqual(sut.numberOfRenderedItemsInTableView(section: 0), 2, "Expected to render two items")
    }
    
    func test_didSelectFirstItemInSection_requestsDidSelectOnce() {
        let sut = makeSUT()
        let givenCell = UITableViewCell()
        let cellController1 = CellControllerStub(tableViewCell: givenCell)
        let section1 = SectionController(headerController: nil, controllers: [cellController1])
        
        sut.updateTableModel(sectionController: [section1])
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cellController1.didSelectCellCount, 1)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        ListViewController()
    }
    
    private final class CellControllerStub: NSObject, CellController {
        private let tableViewCell: UITableViewCell
        var didSelectCellCount = 0
        var didRenderCellCount = 0
        
        init(tableViewCell: UITableViewCell = UITableViewCell()) {
            self.tableViewCell = tableViewCell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            didRenderCellCount += 1
            return tableViewCell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            didSelectCellCount += 1
        }
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
    
    @discardableResult
    func item(at row: Int, in section: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource!
        let indexPath = IndexPath(row: row, section: section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    @discardableResult
    func simulateItemVisible(at row: Int, section: Int) -> UITableViewCell? {
        item(at: row, in: section)
    }
    
    func numberOfRenderedItemsInTableView(section: Int) -> Int {
        tableView.numberOfRows(inSection: section)
    }
    
    func numberOfRenderedSection() -> Int {
        tableView.numberOfSections
    }
}
