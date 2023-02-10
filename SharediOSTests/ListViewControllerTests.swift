//
//  ListiOSTests.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerTests: XCTestCase {
    func test_viewDidLoad_messagesOnRefreshOnce() {
        let sut = makeSUT()
        
        var callCount = 0
        sut.onRefresh = { callCount += 1 }
        
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
    
    func test_update_doesNotRenderOnEmptyList() {
        let sut = makeSUT()
        
        sut.update(sectionController: [])
        
        XCTAssertEqual(sut.numberOfSections, 0)
    }
    
    func test_update_doesNotRenderHeaderOrItems_forItemWithNoSectionAndEmptyList() {
        let sut = makeSUT()
        let sectionController = makeSectionController(headerController: nil, cellControllers: [])
        
        sut.update(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertNil(sut.headerViewIn(section: 0), "Expected not to render a header view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any items")
    }
    
    func test_update_rendersUpdatedItems() {
        let sut = makeSUT()
        let sectionController = makeSectionController(headerController: nil, cellControllers: [CellControllerSpy()])
        
        sut.update(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render 1 section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 item")

        let sectionController1 = makeSectionController(headerController: nil, cellControllers: [CellControllerSpy(), CellControllerSpy()])
        let sectionController2 = makeSectionController(headerController: nil, cellControllers: [CellControllerSpy()])

        sut.update(sectionController: [sectionController1, sectionController2])

        XCTAssertEqual(sut.numberOfSections, 2, "Expected to render two sections")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 2, "Expected to render 2 items in section 1")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 1), 1, "Expected to render 1 item in section 2")
    }
    
    func test_update_renderSectionHeaderAndItems_forItemWithSectionAndNonEmptyList() {
        let sut = makeSUT()
        let itemCell = UITableViewCell()
        let headerView = UIView()
        let cellController = CellControllerSpy(tableViewCell: itemCell)
        let headerController = HeaderControllerStub(view: headerView)
        let sectionController = makeSectionController(headerController: headerController, cellControllers: [cellController])
        
        sut.update(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertEqual(sut.headerViewIn(section: 0), headerView, "Expected header view to be header view")
        
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.item(at: 0, in: 0), itemCell, "Expected rendered item to be item cell")
    }
    
    func test_update_rendersItemsWithoutSectionHeader_forItemWithNoSectionAndNonEmptyList() {
        let sut = makeSUT()
        let itemCell = UITableViewCell()
        let cellController = CellControllerSpy(tableViewCell: itemCell)
        let sectionController = makeSectionController(headerController: nil, cellControllers: [cellController])
        
        sut.update(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertNil(sut.headerViewIn(section: 0), "Expected not to render a header view")
        
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.item(at: 0, in: 0), itemCell, "Expected rendered item to be item cell")
    }
    
    func test_update_rendersSectionHeaderWithoutItems_forItemWithSectionAndEmptyList() {
        let sut = makeSUT()
        let headerView = UIView()
        let headerController = HeaderControllerStub(view: headerView)
        let sectionController = makeSectionController(headerController: headerController, cellControllers: [])

        sut.update(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertEqual(sut.headerViewIn(section: 0), headerView, "Expected header view to be header view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any item")
    }
    
    func test_update_rendersMultipleItemsInSection() {
        let sut = makeSUT()
        let itemCell1 = UITableViewCell()
        let itemCell2 = UITableViewCell()
        let cellController1 = CellControllerSpy(tableViewCell: itemCell1)
        let cellController2 = CellControllerSpy(tableViewCell: itemCell2)
        let sectionController = makeSectionController(headerController: nil, cellControllers: [cellController1, cellController2])
        
        sut.update(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 2, "Expected to render two items")
        XCTAssertEqual(sut.item(at: 0, in: 0), itemCell1, "Expected rendered item to be item cell 1")
        XCTAssertEqual(sut.item(at: 1, in: 0), itemCell2, "Expected rendered item to be item cell 2")
    }
    
    func test_didSelectItem_requestsDidSelectOnce() {
        let sut = makeSUT()
        let cellController = CellControllerSpy()
        let sectionController = makeSectionController(headerController: nil, cellControllers: [cellController])
        
        sut.update(sectionController: [sectionController])
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cellController.didSelectCellCount, 1)
    }
    
    func test_didDeselectItem_requestsDidDeselectOnce() {
        let sut = makeSUT()
        let cellController = CellControllerSpy()
        let sectionController = makeSectionController(headerController: nil, cellControllers: [cellController])
        
        sut.update(sectionController: [sectionController])
        sut.tableView(sut.tableView, didDeselectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cellController.didDeselectCellCount, 1)
    }
}

private extension ListViewControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        ListViewController()
    }
    
    func makeSectionController(headerController: HeaderController?, cellControllers: [CellController]) -> SectionController {
        SectionController(headerController: headerController, cellControllers: cellControllers)
    }
    
    final class CellControllerSpy: NSObject, CellController {
        private let tableViewCell: UITableViewCell
        private(set) var didSelectCellCount = 0
        private(set) var didDeselectCellCount = 0
        
        init(tableViewCell: UITableViewCell = UITableViewCell()) {
            self.tableViewCell = tableViewCell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { tableViewCell }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { didSelectCellCount += 1 }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { didDeselectCellCount += 1 }
    }
    
    final class HeaderControllerStub: HeaderController {
        private let view: UIView
        
        init(view: UIView) {
            self.view = view
        }
        
        func makeHeaderView() -> UIView { view }
    }
}

// Test DSL Helpers
private extension ListViewController {
    var numberOfSections: Int {
        tableView.numberOfSections
    }
    
    func numberOfRenderedItemsIn(section: Int) -> Int {
        tableView.numberOfRows(inSection: section)
    }
    
    func headerViewIn(section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func item(at row: Int, in section: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource!
        let indexPath = IndexPath(row: row, section: section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
