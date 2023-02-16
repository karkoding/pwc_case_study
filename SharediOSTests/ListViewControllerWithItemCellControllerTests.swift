//
//  ListViewControllerWithItemCellControllerTests.swift
//  SharediOS
//
//  Created by Karthik K Manoj on 09/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerWithItemCellControllerTests: XCTestCase {
    func test_viewDidLoad_messagesOnRequestToLoadOnce() {
        let sut = makeSUT()
        
        var callCount = 0
        sut.onRequestToLoad = { callCount += 1 }
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(callCount, 1)
    }
    
    func test_viewDidLoad_messagesConfigureListViewOnce() {
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
        
        sut.display(cellControllers: [])
        
        XCTAssertEqual(sut.numberOfSections, 0)
    }
    
    func test_display_rendersItemCellController() {
        let sut = makeSUT()
        let itemCellView = ItemCellControllerSpy.makeItemCellView()
        
        sut.display(cellControllers: [ItemCellControllerSpy(itemCellView: itemCellView)])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render one section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item")
        XCTAssertEqual(sut.itemAt(section: 0, row: 0), itemCellView, "Expected rendered item to be item cell view")
    }
    
    func test_display_rendersLatestItemCellControllers() {
        let sut = makeSUT()
        sut.display(cellControllers: [ItemCellControllerSpy()])
        
        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render 1 section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 item")

        sut.display(cellControllers: [ItemCellControllerSpy(), ItemCellControllerSpy()])

        XCTAssertEqual(sut.numberOfSections, 2, "Expected to render two sections")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 items in section 1")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 1), 1, "Expected to render 1 item in section 2")
    }
    
    func test_renderHeaderView_forItemCellController() {
        let sut = makeSUT()
        let headerView = UIView()
        let itemCellController = ItemCellControllerSpy(headerView: headerView)
        
        sut.display(cellControllers: [itemCellController])
        
        XCTAssertEqual(sut.headerView(for: 0) , headerView)
    }
    
    func test_renderFooterView_forItemCellController() {
        let sut = makeSUT()
        let footerView = UIView()
        let itemCellController = ItemCellControllerSpy(footerView: footerView)
        
        sut.display(cellControllers: [itemCellController])
        
        XCTAssertEqual(sut.footerView(for: 0), footerView)
    }
    
    func test_didSelectItem_requestsDidSelectOnce() {
        let sut = makeSUT()
        let itemCellController = ItemCellControllerSpy()
        
        sut.display(cellControllers: [itemCellController])
        sut.didSelectItemAt(section: 0, row: 0)
        
        XCTAssertEqual(itemCellController.didSelectCellCount, 1)
    }
    
    func test_didDeselectItem_requestsDidDeselectOnce() {
        let sut = makeSUT()
        let itemCellController = ItemCellControllerSpy()
        
        sut.display(cellControllers: [itemCellController])
        sut.didDeSelectItemAt(section: 0, row: 0)
        
        XCTAssertEqual(itemCellController.didDeselectCellCount, 1)
    }
}

// MARK: - Helpers
extension ListViewControllerWithItemCellControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        let sut = ListViewController()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    final class ItemCellControllerSpy: NSObject, CellController {
        private let headerView: UIView?
        private let footerView: UIView?
        private let itemCellView: UITableViewCell
        private(set) var didSelectCellCount = 0
        private(set) var didDeselectCellCount = 0
        
        init(itemCellView: UITableViewCell = UITableViewCell(), headerView: UIView? = nil, footerView: UIView? = nil) {
            self.itemCellView = itemCellView
            self.headerView = headerView
            self.footerView = footerView
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { itemCellView }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { didSelectCellCount += 1 }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { didDeselectCellCount += 1 }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {  headerView }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { footerView }
        
        static func makeItemCellView() -> UITableViewCell { UITableViewCell() }
    }
}

// Test DSL Helpers
public extension ListViewController {
    var isSeparatorLineVisible: Bool {
        !(tableView.separatorStyle == .none)
    }
    
    var numberOfSections: Int {
        tableView.numberOfSections
    }
    
    var sectionHeaderTopPadding: CGFloat {
        tableView.sectionHeaderTopPadding
    }
    
    func headerView(for section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func footerView(for section: Int) -> UIView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForFooterInSection: section)
    }
    
    func numberOfRenderedItemsIn(section: Int) -> Int {
        tableView.numberOfRows(inSection: section)
    }
    
    func itemAt(section: Int, row: Int) -> UITableViewCell? {
        let dataSource = tableView.dataSource!
        let indexPath = IndexPath(row: row, section: section)
        return dataSource.tableView(tableView, cellForRowAt: indexPath)
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

