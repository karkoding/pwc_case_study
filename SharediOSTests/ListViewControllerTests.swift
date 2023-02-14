//
//  ListiOSTests.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerTests: XCTestCase {
    func test_viewDidLoad_messagesOnRequestToLoadOnce() {
        let sut = makeSUT()
        
        var callCount = 0
        sut.onRequestToLoad = { callCount += 1 }
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_viewDidLoad_messagesConfigureTableViewOnce() {
        let sut = makeSUT()
        
        var callCount = 0
        sut.configureListView = { _ in callCount += 1 }
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_listViewDefaultProperties() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.sectionHeaderTopPadding, 0, "Expected section header top padding to be 0 by default")
        XCTAssertFalse(sut.isSeparatorLineVisible, "Expected no separator line by default")
    }
    
    func test_configureListView_overridesDefaultProperties() {
        let sut = makeSUT()
        
        sut.configureListView = {
            $0.sectionHeaderTopPadding = 20
            $0.separatorStyle = .singleLine
        }
        
        XCTAssertEqual(sut.sectionHeaderTopPadding, 20, "Expected section header top padding to be 20")
        XCTAssertTrue(sut.isSeparatorLineVisible, "Expected a separator line")
    }
    
    func test_display_doesNotRenderOnEmptyList() {
        let sut = makeSUT()
        
        sut.display(sectionController: [])
        
        XCTAssertEqual(sut.numberOfSections, 0)
    }
    
    func test_display_rendersLatestItems() {
        let sut = makeSUT()
        let sectionController = SectionCellControllerSpy()
        
        sut.display(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render 1 section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 item")

        let sectionController1 = SectionCellControllerSpy()
        let sectionController2 = SectionCellControllerSpy()

        sut.display(sectionController: [sectionController1, sectionController2])

        XCTAssertEqual(sut.numberOfSections, 2, "Expected to render two sections")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 2 items in section 1")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 1), 1, "Expected to render 1 item in section 2")
    }
    
    func test_display_rendersItemsWithoutSectionHeader_forItemWithNoSectionAndNonEmptyList() {
        let sut = makeSUT()
        let itemCell = UITableViewCell()
        let sectionController = SectionCellControllerSpy(tableViewCell: itemCell)
        
        sut.display(sectionController: [sectionController])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.item(at: 0, in: 0), itemCell, "Expected rendered item to be item cell")
    }
    
    
    func test_display_rendersMultipleItemsInSection() {
        let sut = makeSUT()
        let itemCell1 = UITableViewCell()
        let itemCell2 = UITableViewCell()
        let sectionController1 = SectionCellControllerSpy(tableViewCell: itemCell1)
        let sectionController2 = SectionCellControllerSpy(tableViewCell: itemCell2)
        
        sut.display(sectionController: [sectionController1, sectionController2])
        
        XCTAssertEqual(sut.numberOfSections, 2, "Expected to render two items")
        XCTAssertEqual(sut.item(at: 0, in: 0), itemCell1, "Expected rendered item to be item cell 1")
        XCTAssertEqual(sut.item(at: 1, in: 1), itemCell2, "Expected rendered item to be item cell 2")
    }
    
    func test_didSelectItem_requestsDidSelectOnce() {
        let sut = makeSUT()
        let sectionController = SectionCellControllerSpy()
        
        sut.display(sectionController: [sectionController])
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sectionController.didSelectCellCount, 1)
    }
    
    func test_didDeselectItem_requestsDidDeselectOnce() {
        let sut = makeSUT()
        let sectionController = SectionCellControllerSpy()
        
        sut.display(sectionController: [sectionController])
        sut.tableView(sut.tableView, didDeselectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(sectionController.didDeselectCellCount, 1)
    }
}

// MARK: - Helpers
extension ListViewControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        let sut = ListViewController()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    final class SectionCellControllerSpy: NSObject, CellController {
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
}

private extension ListViewController {
    var isSeparatorLineVisible: Bool {
        !(tableView.separatorStyle == .none)
    }
    
    var numberOfSections: Int {
        tableView.numberOfSections
    }
    
    var sectionHeaderTopPadding: CGFloat {
        tableView.sectionHeaderTopPadding
    }
    
    func numberOfRenderedItemsIn(section: Int) -> Int {
        tableView.numberOfRows(inSection: section)
    }
    
    func item(at row: Int, in section: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource!
        let indexPath = IndexPath(row: row, section: section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
    }
}
