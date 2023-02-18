//
//  SingleSelectionCellControllerTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 16/02/23.
//

import XCTest
import SharediOS

public final class SingleSelectionCellController: NSObject {
    public private(set) var cellControllers: [CellController]
    
    public init(cellControllers: [CellController]) {
        self.cellControllers = cellControllers
    }
}

extension SingleSelectionCellController: CellController {
    public func numberOfSections(in tableView: UITableView) -> Int {
        cellControllers.reduce(0) { $0 + ($1.numberOfSections?(in: tableView) ?? 1) }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellController(for: section, tableView: tableView).tableView(tableView, numberOfRowsInSection: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(for: indexPath.section, tableView: tableView).tableView(tableView, cellForRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        cellController(for: section, tableView: tableView).tableView?(tableView, viewForHeaderInSection: section)
    }
    
    func cellController(for section: Int, tableView: UITableView) -> CellController {
        var sectionCount = 0
        for controller in cellControllers {
            sectionCount += controller.numberOfSections?(in: tableView) ?? 1
            if section < sectionCount {
                return controller
            }
        }
        
        fatalError("Trying to access non existing cell controller for \(section)")
    }
}


final class SingleSelectionCellControllerTests: XCTestCase {
    func test_init_deliversEmptyOnEmptyList() {
        let sut = makeSUT(cellControllers: [])
        
        XCTAssertTrue(sut.cellControllers.isEmpty)
    }
    
    func test_init_deliversSingleCellController_onSingleCellController() {
        let sut = makeSUT(cellControllers: [ItemCellController()])
        
        XCTAssertEqual(sut.cellControllers.count, 1)
    }
    
    func test_init_deliversMultipleCellControllers_onMultipleCellControllers() {
        let sut = makeSUT(cellControllers: [ItemCellController(), ItemCellController()])
        
        XCTAssertEqual(sut.cellControllers.count, 2)
    }
    
    func test_numberOfSections() {
        let twoSections = TwoSectionCellController(cellControllers: [ItemCellController(), ItemCellController()])
        let threeSections = ThreeSectionCellController(cellControllers: [ItemCellController(), ItemCellController(), ItemCellController()])
        
        let sut = makeSUT(cellControllers: [twoSections, threeSections])

        XCTAssertEqual(sut.numberOfSections(in: UITableView()), 5)
    }

    func test_numberOfRowsInSections() {
        let twoSections = TwoSectionCellController(cellControllers: [ItemCellController(), ItemCellController()])
        let threeSections = ThreeSectionCellController(cellControllers: [ItemCellController(), ItemCellController(), ItemCellController()])
        
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
        
        let item1 = ItemCellController(cell: cell1)
        let item2 = ItemCellController(cell: cell2)

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
    
    func makeItemCellController(cell: UITableViewCell = UITableViewCell()) -> ItemCellController {
        ItemCellController(cell: cell)
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
    
    final class ItemCellController: NSObject, CellController {
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

