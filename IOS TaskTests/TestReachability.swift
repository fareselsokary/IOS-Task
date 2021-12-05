//
//  TestReachability.swift
//  IOS TaskTests
//
//  Created by fares on 05/12/2021.
//

@testable import IOS_Task
import XCTest

class TestReachability: XCTestCase {
    func testIsConnectedToNetwork() throws {
        XCTAssertTrue(Reachability.isConnectedToNetwork())
    }
}
