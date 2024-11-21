//
//  RedBlackTreeMapTests.swift
//  swift-tree
//
//  Created by narumij on 2024/09/23.
//

import XCTest
import RedBlackTreeModule

final class RedBlackTreeMapTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitEmtpy() throws {
        let map = RedBlackTreeMap<Int,Int>()
        XCTAssertEqual(map.count, 0)
        XCTAssertTrue(map.isEmpty)
    }
    
    func testUsage0() throws {
        var map = RedBlackTreeMap<Int,Int>()
        XCTAssertEqual(map[0], nil)
        map[0] = 0
        XCTAssertEqual(map[0], 0)
        XCTAssertEqual(map[1], nil)
        map[0] = nil
        XCTAssertEqual(map[0], nil)
        XCTAssertEqual(map[1], nil)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
