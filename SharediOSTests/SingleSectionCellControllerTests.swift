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
    func test_init_deliversEmptyCellControllersOnEmptyList() {
        let sut = SingleSectionCellController(cellControllers: [])
        
        XCTAssertEqual(sut.cellControllers.count, .zero)
    }
}

// MARK: - Helpers
extension SingleSectionCellControllerTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) {
       
    }
}

