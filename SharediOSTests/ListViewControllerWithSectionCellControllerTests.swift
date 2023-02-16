//
//  ListViewControllerWithSectionCellControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerWithSectionCellControllerTests: XCTestCase {
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
    
    func test_display_rendersSectionItems() {
        let sut = makeSUT()
        
        let itemCellView1 = SingleSectionControllerStub.makeItemCellView()
        let itemCellView2 = SingleSectionControllerStub.makeItemCellView()
        let itemCellView3 = SingleSectionControllerStub.makeItemCellView()
        
        let section1 = SingleSectionControllerStub(itemCellView: itemCellView1)
        let section2 = SingleSectionControllerStub(itemCellView: itemCellView2)
        let section3 = SingleSectionControllerStub(itemCellView: itemCellView3)
        let multiSectionCellController = makeMultipleSectionCellController(cellControllers: [section1, section2, section3])
        
        sut.display(cellControllers: [multiSectionCellController])
        
        XCTAssertEqual(sut.numberOfSections, 3, "Expected to render one section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render an item in section 1")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 1), 1, "Expected to render an item in section 2")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 2), 1, "Expected to render an item in section 3")
        XCTAssertEqual(sut.itemAt(section: 0, row: 0), itemCellView1, "Expected rendered item to be item cell view 1")
        XCTAssertEqual(sut.itemAt(section: 1, row: 0), itemCellView2, "Expected rendered item to be item cell view 2")
        XCTAssertEqual(sut.itemAt(section: 2, row: 0), itemCellView3, "Expected rendered item to be item cell view 3")
    }

    func test_display_rendersLatestSectionItems() {
        let sut = makeSUT()
        
        let itemCellView = SingleSectionControllerStub.makeItemCellView()
        let section  = SingleSectionControllerStub(itemCellView: itemCellView)
        let multiSectionCellController = makeMultipleSectionCellController(cellControllers: [section])
        
        sut.display(cellControllers: [multiSectionCellController])

        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render 1 section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 item")
        XCTAssertEqual(sut.itemAt(section: 0, row: 0), itemCellView, "Expected rendered item to be item cell view 1")

        let itemCellView1 = SingleSectionControllerStub.makeItemCellView()
        let itemCellView2 = SingleSectionControllerStub.makeItemCellView()
        
        let section1 = SingleSectionControllerStub(itemCellView: itemCellView1)
        let section2 = SingleSectionControllerStub(itemCellView: itemCellView2)
        let latestMultiSectionCellController = makeMultipleSectionCellController(cellControllers: [section1, section2])
        
        sut.display(cellControllers: [latestMultiSectionCellController])

        XCTAssertEqual(sut.numberOfSections, 2, "Expected to render two sections")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 items in section 1")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 1), 1, "Expected to render 1 item in section 2")
        XCTAssertEqual(sut.itemAt(section: 0, row: 0), itemCellView1, "Expected rendered item to be item cell view 1")
        XCTAssertEqual(sut.itemAt(section: 1, row: 0), itemCellView2, "Expected rendered item to be item cell view 2")
    }

    func test_rendersHeaderView_forSections() {
        let sut = makeSUT()
        let headerView1 = UIView()
        let headerView2 = UIView()
        let headerView3 = UIView()
    
        let section1 = SingleSectionControllerStub(headerView: headerView1)
        let section2 = SingleSectionControllerStub(headerView: headerView2)
        let section3 = SingleSectionControllerStub(headerView: headerView3)
            
        let multiSectionCellController = makeMultipleSectionCellController(cellControllers: [section1, section2, section3])

        sut.display(cellControllers: [multiSectionCellController])

        XCTAssertEqual(sut.headerView(for: 0) , headerView1)
        XCTAssertEqual(sut.headerView(for: 1) , headerView2)
        XCTAssertEqual(sut.headerView(for: 2) , headerView3)
    }

    func test_rendersFooterView_forSections() {
        let sut = makeSUT()
        let footerView1 = UIView()
        let footerView2 = UIView()
        let footerView3 = UIView()
        
        let section1 = SingleSectionControllerStub(footerView: footerView1)
        let section2 = SingleSectionControllerStub(footerView: footerView2)
        let section3 = SingleSectionControllerStub(footerView: footerView3)
            
        let multiSectionCellController = makeMultipleSectionCellController(cellControllers: [section1, section2, section3])

        sut.display(cellControllers: [multiSectionCellController])

        XCTAssertEqual(sut.footerView(for: 0) , footerView1)
        XCTAssertEqual(sut.footerView(for: 1) , footerView2)
        XCTAssertEqual(sut.footerView(for: 2) , footerView3)
    }
}

// MARK: - Helpers
extension ListViewControllerWithSectionCellControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        let sut = ListViewController()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    func makeMultipleSectionCellController(
        cellControllers: [CellController],
        itemCellView: UITableViewCell = UITableViewCell(),
        headerView: UIView? = nil,
        footerView: UIView? = nil
    ) -> MultipleSectionCellController {
        MultipleSectionCellController(
            cellControllers: cellControllers,
            itemCellView: itemCellView,
            headerView: headerView,
            footerView: footerView
        )
    }
    
    final class MultipleSectionCellController: NSObject, CellController {
        private let cellControllers: [CellController]
        private let headerView: UIView?
        private let footerView: UIView?
        private let itemCellView: UITableViewCell
        
        init(cellControllers: [CellController],itemCellView: UITableViewCell = UITableViewCell(), headerView: UIView? = nil, footerView: UIView? = nil) {
            self.cellControllers = cellControllers
            self.itemCellView = itemCellView
            self.headerView = headerView
            self.footerView = footerView
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            cellControllers.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            cellControllers[section].tableView(tableView, numberOfRowsInSection: section)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cellControllers[indexPath.section].tableView(tableView, cellForRowAt: indexPath)
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            cellControllers[section].tableView?(tableView, viewForHeaderInSection: section)
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            cellControllers[section].tableView?(tableView, viewForFooterInSection: section)
        }
    }
    
    final class SingleSectionControllerStub: NSObject, CellController {
        private let headerView: UIView?
        private let footerView: UIView?
        private let itemCellView: UITableViewCell
        
        init(itemCellView: UITableViewCell = UITableViewCell(), headerView: UIView? = nil, footerView: UIView? = nil) {
            self.itemCellView = itemCellView
            self.headerView = headerView
            self.footerView = footerView
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { itemCellView }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {  headerView }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { footerView }
        
        static func makeItemCellView() -> UITableViewCell { UITableViewCell() }
    }
}

