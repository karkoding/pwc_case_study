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
    
//    func test_numberOfSections() {
//        let multiSection1 = MultiSectionCellController(numberOfSections: 2)
//        let multisection2 = MultiSectionCellController(numberOfSections: 3)
//
//        let sut = makeSUT(cellControllers: [multiSection1, multisection2])
//
//        XCTAssertEqual(sut.numberOfSections(in: UITableView()), 0)
//    }
//
//    func test_numberOfRowsInSections() {
//        let multiSection1 = MultiSectionCellController(numberOfSections: 2, numberOfItemsInSection: 2)
//        let multisection2 = MultiSectionCellController(numberOfSections: 3, numberOfItemsInSection: 3)
//
//        let sut = makeSUT(cellControllers: [multiSection1, multisection2])
//
//        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 0), 2)
//        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 1), 2)
//        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 2), 3)
//        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 3), 3)
//        XCTAssertEqual(sut.tableView(UITableView(), numberOfRowsInSection: 4), 3)
//    }
//
    func test_cellForRowAt_deliversItemsInSection() {
        let section1Items = [UITableViewCell(), UITableViewCell()]
        let section2Items = [UITableViewCell(), UITableViewCell()]
        let section3Items = [UITableViewCell(), UITableViewCell()]
        let section4Items = [UITableViewCell(), UITableViewCell()]
        
        let multiSection1 = MultiSectionCellController(cells: [section1Items, section2Items])
        let multisection2 = MultiSectionCellController(cells: [section3Items, section4Items])
        
        let sut = makeSUT(cellControllers: [multiSection1, multisection2])
    

        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 0)), section1Items[0])
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 1, section: 0)), section1Items[1])

        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 1)), section2Items[0])
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 1, section: 1)), section2Items[1])

        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 2)), section3Items[0])
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 1, section: 2)), section3Items[1])

        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 0, section: 3)), section4Items[0])
        XCTAssertEqual(sut.tableView(UITableView(), cellForRowAt: IndexPath(row: 1, section: 3)), section4Items[1])
    }
    
    
    /*
    func test_viewForHeaderInSection_deliversHeaderView() {
        let headerView = UIView()
        let sut = makeSUT(cellControllers: [ItemCellController()], headerView: headerView)
        
        XCTAssertEqual(sut.tableView(UITableView(), viewForHeaderInSection: section), headerView)
    }
    
    func test_viewForFooterInSection_deliversFooterView() {
        let footerView = UIView()
        let sut = makeSUT(cellControllers: [ItemCellController()], footerView: footerView)
        
        XCTAssertEqual(sut.tableView(UITableView(), viewForFooterInSection: section), footerView)
    }
    
    func test_viewForHeaderInSection_doesNotDeliverHeaderView_onNilHeader() {
        let sut = makeSUT(cellControllers: [ItemCellController()], headerView: nil)
        
        XCTAssertNil(sut.tableView(UITableView(), viewForHeaderInSection: section))
    }
    
    func test_viewForFooterInSection_doesNotDeliverFooterView_onNilFooter() {
        let sut = makeSUT(cellControllers: [ItemCellController()], footerView: nil)
        
        XCTAssertNil(sut.tableView(UITableView(), viewForFooterInSection: section))
    }
    
    func test_didSelectRowAt_selectsItem() {
        let item1 = makeItemCellController()
        let sut = makeSUT(cellControllers: [item1])
        
        XCTAssertFalse(item1.didSelect)

        sut.tableView(UITableView(), didSelectRowAt: IndexPath(row: 0, section: section))
        
        XCTAssertTrue(item1.didSelect)
    }
    
    func test_didDeselectRowAt_deselectsItem() {
        let item1 = makeItemCellController()
        let sut = makeSUT(cellControllers: [item1])
        
        XCTAssertFalse(item1.didDeselect)
        
        sut.tableView(UITableView(), didDeselectRowAt: IndexPath(row: 0, section: section))
        
        XCTAssertTrue(item1.didDeselect)
    }
 */
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
    
    final class MultiSectionCellController: NSObject, CellController {
        private let cells: [[UITableViewCell]]
        
        init(cells: [[UITableViewCell]] = []) {
            self.cells = cells
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            cells.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            cells[section].count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var section = indexPath.section
            
            if indexPath.section >= cells.count { section = indexPath.section - cells.count }
            
            return cells[section][indexPath.item]
        }
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

