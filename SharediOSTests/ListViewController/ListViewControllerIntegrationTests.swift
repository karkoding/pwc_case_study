//
//  ListViewControllerIntegrationTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 18/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerIntegrationTests: XCTestCase {
    func test_display_deliversFourSections() {
        let sut = makeSUT()
        let section1 = SectionCellControllerStub()
        let section2 = SectionCellControllerStub()
        let section3 = SectionCellControllerStub()
        let singleSelectionCellController = makeSingleSelectionCellController(cellControllers: [section1, section2, section3])
        
        let section4 = SectionCellControllerStub()
        let multiSelectionCellController = makeMultiSelectionCellController(cellControllers: [section4])
    
        sut.display(cellControllers: [singleSelectionCellController, multiSelectionCellController]) // Crashes
        
        XCTAssertEqual(sut.numberOfSections, 4, "Expected to render 4 sections")
    }
}

// MARK: - Helpers
extension ListViewControllerIntegrationTests {
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> ListViewController {
        let sut = ListViewController()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
    func makeSingleSelectionCellController(cellControllers: [CellController]) -> SingleSelectionCellController {
        SingleSelectionCellController(cellControllers: cellControllers)
    }
    
    func makeMultiSelectionCellController(cellControllers: [CellController]) -> MultiSelectionCellController {
        MultiSelectionCellController(cellControllers: cellControllers)
    }
    
    final class SectionCellControllerStub: NSObject, CellController {
        func numberOfSections(in tableView: UITableView) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { UITableViewCell() }
    }
}
