//
//  SingleSectionCellControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import XCTest
import SharediOS

class SingleSectionCellController {
    private(set) var cellControllers: [CellController]
    private(set) var headerView: UIView?
    private(set) var footerView: UIView?
    
    init(cellControllers: [CellController], headerView: UIView?, footerView: UIView?) {
        self.cellControllers = cellControllers
        self.headerView = headerView
        self.footerView = footerView
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
}

// MARK: - Helpers
extension SingleSectionCellControllerTests {
    func makeSUT(
        cellControllers: [CellController] = [],
        headerView: UIView? = nil,
        footerView: UIView? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SingleSectionCellController {
        let sut = SingleSectionCellController(cellControllers: cellControllers, headerView: headerView, footerView: footerView)
        trackForMemoryLeak(sut)
        return sut
    }
    
    final class ItemCellController: NSObject, CellController {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
    }
}

