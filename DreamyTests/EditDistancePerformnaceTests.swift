//
//  DreamyTests.swift
//  DreamyTests
//
//  Created by Reynaldo Aguilar on 5/12/2024.
//

import XCTest
@testable import Dreamy

final class EditDistancePerformnaceTests: XCTestCase {
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let words = Array(repeating: "a", count: 500)
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = EditDistance(fromWords: words, toWords: words).editActions()
        }
    }

}
