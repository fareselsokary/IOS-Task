//
//  URLEncodingTests.swift
//  IOS TaskTests
//
//  Created by fares on 05/12/2021.
//

@testable import IOS_Task
import XCTest

class URLEncodingTests: XCTestCase {
    func testUrlWithQureryItem() throws {
        let hostUrl = "http://openlibrary.org/"
        let param = ["title": "Lord of ther ring"]
        let wrongUrl = hostUrl + "author?title=Lord of ther ring"
        let corretUrl = "http://openlibrary.org/author?title=Lord%20of%20ther%20ring"
        XCTAssertNotEqual(URLEncoding.queryItems(baseUrl: hostUrl,
                                                 endPoint: "author",
                                                 parameters: param).value,
                          wrongUrl)

        XCTAssertEqual(URLEncoding.queryItems(baseUrl: hostUrl,
                                              endPoint: "author",
                                              parameters: param).value,
                       corretUrl)
        
        XCTAssertEqual(URLEncoding.queryItems(baseUrl: hostUrl,
                                              endPoint: "",
                                              parameters: [:]).value,
                       hostUrl)
    }

    func testUrlWithArgumant() throws {
        let hostUrl = "http://openlibrary.org/%@/work/%@"
        let param = ["api",
                     "title"]
        let wrongUrl = "http://openlibrary.org/%@/work/%@"
        let corretUrl = "http://openlibrary.org/api/work/title"

        XCTAssertNotEqual(URLEncoding.arguments(baseUrl: hostUrl, endPoint: "", arguments: param).value,
                          wrongUrl)

        XCTAssertEqual(URLEncoding.arguments(baseUrl: hostUrl, endPoint: "", arguments: param).value,
                       corretUrl)
    }
}
