//
//  SingleSelectionCellControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import XCTest
import SharediOS

// THIS TEST IS IN PROGRESS.

final class SingleSelectionCellControllerTests: XCTestCase {
    func test_init_deliversEmptyOnEmptyList() {
        let sut = makeSUT(cellControllers: [])
        
        XCTAssertTrue(sut.cellControllers.isEmpty)
    }
    
    func test_init_deliversSingleCellController_onSingleCellController() {
        let sut = makeSUT(cellControllers: [ItemCellControllerStub()])
        
        XCTAssertEqual(sut.cellControllers.count, 1)
    }
    
    func test_init_deliversMultipleCellControllers_onMultipleCellControllers() {
        let sut = makeSUT(cellControllers: [ItemCellControllerStub(), ItemCellControllerStub()])
        
        XCTAssertEqual(sut.cellControllers.count, 2)
    }
    
    func test_numberOfSections() {
        let twoSections = TwoSectionCellController(cellControllers: [ItemCellControllerStub(), ItemCellControllerStub()])
        let threeSections = ThreeSectionCellController(cellControllers: [ItemCellControllerStub(), ItemCellControllerStub(), ItemCellControllerStub()])
        
        let sut = makeSUT(cellControllers: [twoSections, threeSections])

        XCTAssertEqual(sut.numberOfSections(in: UITableView()), 5)
    }

    func test_numberOfRowsInSections() {
        let twoSections = TwoSectionCellController(cellControllers: [ItemCellControllerStub(), ItemCellControllerStub()])
        let threeSections = ThreeSectionCellController(cellControllers: [ItemCellControllerStub(), ItemCellControllerStub(), ItemCellControllerStub()])
        
        let sut = makeSUT(cellControllers: [twoSections, threeSections])

        XCTAssertEqual(sut.numberOfSections(in: UITableView()), 5)

        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 1), 2)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 2), 3)
        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 3), 3)
    }

    func test_cellForRowAt_deliversItemsInSection() {
        let cell1 = UITableViewCell()
        let cell2 = UITableViewCell()
        
        let item1 = ItemCellControllerStub(cell: cell1)
        let item2 = ItemCellControllerStub(cell: cell2)

        let twoSections = TwoSectionCellController(cellControllers: [item1])
        let threeSections = ThreeSectionCellController(cellControllers: [item2])

        let sut = makeSUT(cellControllers: [twoSections, threeSections])

        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0)), cell1)
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 1)), cell1)
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 2)), cell2)
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 3)), cell2)
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 4)), cell2)
    }
}

// MARK: - Helpers
private extension SingleSelectionCellControllerTests {
    var section: Int { 0 }
    
    func makeSUT(
        cellControllers: [CellController] = [],
        headerView: UIView? = nil,
        footerView: UIView? = nil,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> SingleSelectionCellController {
        let sut = SingleSelectionCellController(cellControllers: cellControllers)
        trackForMemoryLeak(sut)
        return sut
    }
    
    func makeItemCellController(cell: UITableViewCell = UITableViewCell()) -> ItemCellControllerStub {
        ItemCellControllerStub(cell: cell)
    }
    
    final class TwoSectionCellController: NSObject, CellController {
        private let cellControllers: [CellController]
        
        init(cellControllers: [CellController]) {
            self.cellControllers = cellControllers
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            2
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            cellControllers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cellControllers[indexPath.item].tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    final class ThreeSectionCellController: NSObject, CellController {
        private let cellControllers: [CellController]
        
        init(cellControllers: [CellController]) {
            self.cellControllers = cellControllers
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            3
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            cellControllers.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            cellControllers[indexPath.item].tableView(tableView, cellForRowAt: indexPath)
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            cellControllers[section].tableView?(tableView, viewForHeaderInSection: section)
        }
    }
    
    final class ItemCellControllerStub: NSObject, CellController {
        private let cell: UITableViewCell
        private let headerView: UIView?
        private(set) var didSelect = false
        private(set) var didDeselect = false
        
        init(cell: UITableViewCell = UITableViewCell(), headerView: UIView? = nil) {
            self.cell = cell
            self.headerView = headerView
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { cell }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { headerView }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { didSelect = true }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { didDeselect = true }
    }
}

