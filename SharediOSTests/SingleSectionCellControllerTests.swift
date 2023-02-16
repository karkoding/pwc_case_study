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
    
    init(cellControllers: [CellController]) {
        self.cellControllers = cellControllers
    }
    
}

final class SingleSectionCellControllerTests: XCTestCase {
    func test_init_deliversEmptyCellControllers() {
        let sut = SingleSectionCellController(cellControllers: [])
        
        XCTAssertEqual(sut.cellControllers.count, .zero)
    }
    
    func test_init_deliversSingleCellController() {
        let sut = SingleSectionCellController(cellControllers: [ItemCellController()])
        
        XCTAssertEqual(sut.cellControllers.count, 1)
    }
    
    func test_init_deliversMoreThanOneCellControllers() {
        let sut = SingleSectionCellController(cellControllers: [ItemCellController(), ItemCellController()])
        
        XCTAssertEqual(sut.cellControllers.count, 2)
    }
}

// MARK: - Helpers
extension SingleSectionCellControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) {
       
    }
    
    final class ItemCellController: NSObject, CellController {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
    }
}

