//
//  SectionCellControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import XCTest
import SharediOS

final class SectionCellControllerTests: XCTestCase {
    func test_init_deliversEmptyCellController_onEmptyList() {
        let sut = makeSUT(cellControllers: [])
        
        XCTAssertEqual(sut.cellControllers.count, .zero)
    }
    
    func test_init_deliversSingleCellController_onSingleCellController() {
        let sut = makeSUT(cellControllers: [ItemCellController()])
        
        XCTAssertEqual(sut.cellControllers.count, 1)
    }
    
    func test_init_deliversMultipleCellControllers_onMultipleCellControllers() {
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
    
    func test_init_doesNotDeliversHeaderView_onNilValue() {
        let sut = makeSUT(headerView: nil)
        
        XCTAssertNil(sut.headerView)
    }
    
    func test_intit_doesNotDeliverFooterView_onNilValue() {
        let sut = makeSUT(footerView: nil)
        
        XCTAssertNil(sut.footerView)
    }
    
    func test_numberOfSections() {
        let sut = makeSUT(cellControllers: [makeItemCellController()])
        
        XCTAssertEqual(sut.numberOfSections(in: UITableView()), 1)
    }
    
    func test_numberOfRowsInSection() {
        let sut = makeSUT(cellControllers: [makeItemCellController(), makeItemCellController()])
        
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 1), 2)
    }
    
    func test_deliversItems_InSection() {
        let itemCell1 = UITableViewCell()
        let itemCell2 = UITableViewCell()
        let item1 = makeItemCellController(cell: itemCell1)
        let item2 = makeItemCellController(cell: itemCell2)
        let sut = makeSUT(cellControllers: [item1, item2])
        
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0)), itemCell1)
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 1, section: 0)), itemCell2)
    }
    
    func test_deliversHeaderViewForSection() {
        let headerView = UIView()
        let sut = makeSUT(cellControllers: [ItemCellController()], headerView: headerView)
        
        XCTAssertEqual(sut.tableView(UITableView(), viewForHeaderInSection: 0), headerView)
    }
    
    func test_footerView_deliversHeaderViewForSection() {
        let footerView = UIView()
        let sut = makeSUT(cellControllers: [ItemCellController()], footerView: footerView)
        
        XCTAssertEqual(sut.tableView(UITableView(), viewForFooterInSection: 0), footerView)
    }
    
    func test_didSelectAnItem_inSection() {
        let item1 = makeItemCellController()
        let sut = makeSUT(cellControllers: [item1])
        
        XCTAssertFalse(item1.didSelect)
        
        sut.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(item1.didSelect)
    }
    
    func test_didDeselectAnItem_inSection() {
        let item1 = makeItemCellController()
        let sut = makeSUT(cellControllers: [item1])
        
        XCTAssertFalse(item1.didDeselect)
        
        sut.tableView(UITableView(), didDeselectRowAt: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(item1.didDeselect)
    }
}

// MARK: - Helpers
private extension SectionCellControllerTests {
    func makeSUT(
        cellControllers: [CellController] = [],
        headerView: UIView? = nil,
        footerView: UIView? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SectionCellController {
        let sut = SectionCellController(
            cellControllers: cellControllers,
            headerView: headerView,
            footerView: footerView
        )
        trackForMemoryLeak(sut)
        return sut
    }
    
    func makeItemCellController(cell: UITableViewCell = UITableViewCell()) -> ItemCellController {
        ItemCellController(cell: cell)
    }
    
    final class ItemCellController: NSObject, CellController {
        private let cell: UITableViewCell
        private(set) var didSelect = false
        private(set) var didDeselect = false
        
        init(cell: UITableViewCell = UITableViewCell()) {
            self.cell = cell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { cell }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { didSelect = true }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { didDeselect = true }
    }
}

