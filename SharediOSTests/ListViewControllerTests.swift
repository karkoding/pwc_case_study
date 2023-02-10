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
    
    func test_update_doesNotRenderOnEmptyList() {
        let sut = makeSUT()
        
        sut.update(sectionController: [])
        
        XCTAssertEqual(sut.numberOfSections, 0)
    }
    
    func test_update_doesNotRenderSectionOrItems_forItemWithNoSectionAndEmptyList() {
        let sut = makeSUT()
        let section = SectionController(headerController: nil, controllers: [])
        
        sut.update(sectionController: [section])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertNil(sut.viewForHeaderIn(section: 0), "Expected not to render a header view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any items")
    }
    
    func test_update_renderSectionAndItems_forItemWithSectionAndNonEmptyList() {
        let sut = makeSUT()
        let givenCell = UITableViewCell()
        let givenView = UIView()
        let cellController = CellControllerSpy(tableViewCell: givenCell)
        let headerController = HeaderControllerStub(view: givenView)
        let section = SectionController(headerController: headerController, controllers: [cellController])
        
        sut.update(sectionController: [section])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertEqual(sut.viewForHeaderIn(section: 0), givenView, "Expected to render given view")
        
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.item(at: 0, in: 0), givenCell, "Expected to render given cell")
    }
    
    func test_update_rendersItemsWithoutSection_forItemWithNoSectionAndNonEmptyList() {
        let sut = makeSUT()
        let givenCell = UITableViewCell()
        let cellController = CellControllerSpy(tableViewCell: givenCell)
        let section = SectionController(headerController: nil, controllers: [cellController])
        
        sut.update(sectionController: [section])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertNil(sut.viewForHeaderIn(section: 0), "Expected not to render a header view")
        
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.item(at: 0, in: 0), givenCell, "Expected to render the given cell")
    }
    
    func test_update_rendersSectionWithoutItems_forItemWithSectionAndEmptyList() {
        let sut = makeSUT()
        let givenView = UIView()
        let headerController = HeaderControllerStub(view: givenView)
        let section = SectionController(headerController: headerController, controllers: [])
        
        sut.update(sectionController: [section])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertEqual(sut.viewForHeaderIn(section: 0), givenView, "Expected to render given view")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 0, "Expected not to render any item")
    }
    
    func test_update_rendersMultipleItemsInSection() {
        let sut = makeSUT()
        let givenCell1 = UITableViewCell()
        let givenCell2 = UITableViewCell()
        let cellController1 = CellControllerSpy(tableViewCell: givenCell1)
        let cellController2 = CellControllerSpy(tableViewCell: givenCell2)
        let section1 = SectionController(headerController: nil, controllers: [cellController1, cellController2])
        
        sut.update(sectionController: [section1])
        
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 2, "Expected to render two items")
        XCTAssertEqual(sut.item(at: 0, in: 0), givenCell1, "Expected to render first given cell")
        XCTAssertEqual(sut.item(at: 1, in: 0), givenCell2, "Expected to render second given cell")
    }
    
    func test_update_rendersUpdatedItems() {
        let sut = makeSUT()
        let section = SectionController(headerController: nil, controllers: [CellControllerSpy()])
        
        sut.update(sectionController: [section])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render 1 section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 item")

        let section1 = SectionController(headerController: nil, controllers: [CellControllerSpy(), CellControllerSpy()])
        let section2 = SectionController(headerController: nil, controllers: [CellControllerSpy()])

        sut.update(sectionController: [section1, section2])

        XCTAssertEqual(sut.numberOfSections, 2, "Expected to render two sections")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 2, "Expected to render 2 items in section 1")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 1), 1, "Expected to render 1 item in section 2")
    }
    
    func test_didSelectItem_requestsDidSelectOnce() {
        let sut = makeSUT()
        let givenCell = UITableViewCell()
        let cellController = CellControllerSpy(tableViewCell: givenCell)
        let section = SectionController(headerController: nil, controllers: [cellController])
        
        sut.update(sectionController: [section])
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(cellController.didSelectCellCount, 1)
    }
}

private extension ListViewControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        ListViewController()
    }
    
    final class CellControllerSpy: NSObject, CellController {
        private let tableViewCell: UITableViewCell
        private(set) var didSelectCellCount = 0
        
        init(tableViewCell: UITableViewCell = UITableViewCell()) {
            self.tableViewCell = tableViewCell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { tableViewCell }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            didSelectCellCount += 1
        }
    }
    
    final class HeaderControllerStub: HeaderController {
        private let view: UIView
        
        init(view: UIView) {
            self.view = view
        }
        
        func makeHeaderView() -> UIView { view }
    }
}

private extension ListViewController {
    func viewForHeaderIn(section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func item(at row: Int, in section: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource!
        let indexPath = IndexPath(row: row, section: section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
    
    func numberOfRenderedItemsIn(section: Int) -> Int {
        tableView.numberOfRows(inSection: section)
    }
    
    var numberOfSections: Int {
        tableView.numberOfSections
    }
}
