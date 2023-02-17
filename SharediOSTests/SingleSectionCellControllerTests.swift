//
//  SingleSectionCellControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import XCTest
import SharediOS

class SectionCellController: NSObject, CellController {
    private(set) var cellControllers: [CellController]
    private(set) var headerView: UIView?
    private(set) var footerView: UIView?
    
    init(cellControllers: [CellController], headerView: UIView?, footerView: UIView?) {
        self.cellControllers = cellControllers
        self.headerView = headerView
        self.footerView = footerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellControllers[indexPath.item].tableView(tableView, cellForRowAt: indexPath)
    }
}

final class SingleSectionCellControllerTests: XCTestCase {
    func test_init_deliversEmptyCellController_onEmptyList() {
        let sut = makeSUT(cellControllers: [])
        
        XCTAssertEqual(sut.cellControllers.count, .zero)
    }
    
    func test_init_deliversSingleCellController_onSingleCellController() {
        let sut = makeSUT(cellControllers: [ItemCellController()])
        
        XCTAssertEqual(sut.cellControllers.count, 1)
    }
    
    func test_init_deliversTwoCellControllers_onTwoCellControllers() {
        let sut = makeSUT(cellControllers: [ItemCellController(), ItemCellController()])
        
        XCTAssertEqual(sut.cellControllers.count, 2)
    }
    
    func test_init_deliversHeaderView_onNonNilValue() {
        let headerView = UIView()
        let sut = makeSUT(headerView: headerView)
        
        XCTAssertEqual(sut.headerView, headerView)
    }
    
    func test_init_deliversFooterView_onNonNilValue() {
        let footerView = UIView()
        let sut = makeSUT(footerView: footerView)
        
        XCTAssertEqual(sut.footerView, footerView)
    }
    
    func test_intit_deliversNoHeaderView_onNilValue() {
        let sut = makeSUT(headerView: nil)
        
        XCTAssertNil(sut.headerView)
    }
    
    func test_intit_deliversNoFooterView_onNilValue() {
        let sut = makeSUT(footerView: nil)
        
        XCTAssertNil(sut.footerView)
    }
    
    func test_numberOfSections() {
        let sut = makeSUT(cellControllers: [ItemCellController()])
        
        XCTAssertEqual(sut.numberOfSections(in: UITableView()), 1)
    }
    
    func test_numberOfRowsInSection() {
        let sut = makeSUT(cellControllers: [ItemCellController(), ItemCellController()])
        
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 1), 2)
    }
    
    func test_deliversItems_InSection() {
        let itemCell1 = UITableViewCell()
        let itemCell2 = UITableViewCell()
        let item1 = ItemCellController(cell: itemCell1)
        let item2 = ItemCellController(cell: itemCell2)
        
        let sut = makeSUT(cellControllers: [item1, item2])
        
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0)), itemCell1)
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 1, section: 0)), itemCell2)
    }
}

// MARK: - Helpers
extension SingleSectionCellControllerTests {
    func makeSUT(
        cellControllers: [CellController] = [],
        headerView: UIView? = nil,
        footerView: UIView? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SectionCellController {
        let sut = SectionCellController(cellControllers: cellControllers, headerView: headerView, footerView: footerView)
        trackForMemoryLeak(sut)
        return sut
    }
    
    final class ItemCellController: NSObject, CellController {
        private let cell: UITableViewCell
        
        init(cell: UITableViewCell = UITableViewCell()) {
            self.cell = cell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cell
        }
    }
}

