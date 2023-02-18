//
//  ListViewControllerIntegrationTests.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 18/02/23.
//

import XCTest
import SharediOS

final class ListViewControllerIntegrationTests: XCTestCase {
    func test_numberOfSections_delivers4Sections() {
        let sut = makeSUT()
        let section1 = SectionCellControllerSpy()
        let section2 = SectionCellControllerSpy()
        let section3 = SectionCellControllerSpy()
        let singleSelectionCellController = makeSingleSelectionCellController(cellControllers: [section1, section2, section3])
        
        let section4 = SectionCellControllerSpy()
        let multiSelectionCellController = makeMultiSelectionCellController(cellControllers: [section4])
        
        let dataSource: [CellController] = [singleSelectionCellController, multiSelectionCellController]
         
        sut.display(cellControllers: dataSource) // Crashes 
        
        XCTAssertEqual(sut.numberOfSections, 4, "Expected to render 4 section")
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
    
    final class SectionCellControllerSpy: NSObject, CellController {
        private let headerView: UIView?
        private let footerView: UIView?
        private let itemCellView: UITableViewCell
        private(set) var didSelectCellCount = 0
        private(set) var didDeselectCellCount = 0
        
        init(itemCellView: UITableViewCell = UITableViewCell(), headerView: UIView? = nil, footerView: UIView? = nil) {
            self.itemCellView = itemCellView
            self.headerView = headerView
            self.footerView = footerView
        }
        
        func numberOfSections(in tableView: UITableView) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { itemCellView }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { didSelectCellCount += 1 }
        
        func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) { didDeselectCellCount += 1 }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {  headerView }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { footerView }
        
        static func makeItemCell() -> UITableViewCell { UITableViewCell() }
    }
}
