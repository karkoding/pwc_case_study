//
//  ListViewControllerWithMultiSectionCellControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerWithMultiSectionCellControllerTests: XCTestCase {
    func test_display_rendersSectionItems() {
        let sut = makeSUT()
        
        let itemCellView1 = SingleSectionCellControllerStub.makeItemCellView()
        let itemCellView2 = SingleSectionCellControllerStub.makeItemCellView()
        let itemCellView3 = SingleSectionCellControllerStub.makeItemCellView()
        
        let section1 = SingleSectionCellControllerStub(itemCellView: itemCellView1)
        let section2 = SingleSectionCellControllerStub(itemCellView: itemCellView2)
        let section3 = SingleSectionCellControllerStub(itemCellView: itemCellView3)
        let multiSection = makeMultiSectionCellController(cellControllers: [section1, section2, section3])
        
        sut.display(cellControllers: [multiSection])
        
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
        
        let itemCellView = SingleSectionCellControllerStub.makeItemCellView()
        let section  = SingleSectionCellControllerStub(itemCellView: itemCellView)
        let multiSection = makeMultiSectionCellController(cellControllers: [section])
        
        sut.display(cellControllers: [multiSection])

        XCTAssertEqual(sut.numberOfSections, 1, "Expected to render 1 section")
        XCTAssertEqual(sut.numberOfRenderedItemsIn(section: 0), 1, "Expected to render 1 item")
        XCTAssertEqual(sut.itemAt(section: 0, row: 0), itemCellView, "Expected rendered item to be item cell view 1")

        let itemCellView1 = SingleSectionCellControllerStub.makeItemCellView()
        let itemCellView2 = SingleSectionCellControllerStub.makeItemCellView()
        
        let section1 = SingleSectionCellControllerStub(itemCellView: itemCellView1)
        let section2 = SingleSectionCellControllerStub(itemCellView: itemCellView2)
        let latestMultiSection = makeMultiSectionCellController(cellControllers: [section1, section2])
        
        sut.display(cellControllers: [latestMultiSection])

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
    
        let section1 = SingleSectionCellControllerStub(headerView: headerView1)
        let section2 = SingleSectionCellControllerStub(headerView: headerView2)
        let section3 = SingleSectionCellControllerStub(headerView: headerView3)
            
        let multiSection = makeMultiSectionCellController(cellControllers: [section1, section2, section3])

        sut.display(cellControllers: [multiSection])

        XCTAssertEqual(sut.headerView(for: 0) , headerView1, "Expected section 1 to have header view 1")
        XCTAssertEqual(sut.headerView(for: 1) , headerView2, "Expected section 2 to have header view 2")
        XCTAssertEqual(sut.headerView(for: 2) , headerView3, "Expected section 3 to have header view 3")
    }

    func test_rendersFooterView_forSections() {
        let sut = makeSUT()
        let footerView1 = UIView()
        let footerView2 = UIView()
        let footerView3 = UIView()
        
        let section1 = SingleSectionCellControllerStub(footerView: footerView1)
        let section2 = SingleSectionCellControllerStub(footerView: footerView2)
        let section3 = SingleSectionCellControllerStub(footerView: footerView3)
            
        let multiSection = makeMultiSectionCellController(cellControllers: [section1, section2, section3])

        sut.display(cellControllers: [multiSection])

        XCTAssertEqual(sut.footerView(for: 0) , footerView1, "Expected section 1 to have footer view 1")
        XCTAssertEqual(sut.footerView(for: 1) , footerView2, "Expected section 2 to have footer view 2")
        XCTAssertEqual(sut.footerView(for: 2) , footerView3, "Expected section 3 to have footer view 3")
    }
}

// MARK: - Helpers
extension ListViewControllerWithMultiSectionCellControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        let sut = ListViewController()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    func makeMultiSectionCellController(cellControllers: [CellController]) -> MultiSectionCellControllerStub {
        MultiSectionCellControllerStub(cellControllers: cellControllers)
    }
    
    final class MultiSectionCellControllerStub: NSObject, CellController {
        private let cellControllers: [CellController]
   
        init(cellControllers: [CellController]) {
            self.cellControllers = cellControllers
        }
        
        func numberOfSections(in tableView: UITableView) -> Int { cellControllers.count }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            cellControllerFor(section: section).tableView(tableView, numberOfRowsInSection: section)
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cellControllerFor(section: indexPath.section).tableView(tableView, cellForRowAt: indexPath)
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            cellControllerFor(section: section).tableView?(tableView, viewForHeaderInSection: section)
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            cellControllerFor(section: section).tableView?(tableView, viewForFooterInSection: section)
        }
        
        func cellControllerFor(section: Int) -> CellController {
            cellControllers[section]
        }
    }
    
    final class SingleSectionCellControllerStub: NSObject, CellController {
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

