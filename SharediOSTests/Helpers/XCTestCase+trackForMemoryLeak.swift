//
//  XCTestCase+trackForMemoryLeak.swift
//  SharediOSTests
//
//  Created by Karthik K Manoj on 11/02/23.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
