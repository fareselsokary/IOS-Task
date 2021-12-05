//
//  DocumentListViewModelTests.swift
//  IOS TaskTests
//
//  Created by fares on 05/12/2021.
//

@testable import IOS_Task
import XCTest

class DocumentListViewModelTests: XCTestCase {
    var viewModel: DocumentListViewModel!
    var apiService: DocumentListServiceType!

    override func setUp() {
        apiService = DocumentListService()
        viewModel = DocumentListViewModel(apiService: apiService)
    }

    func testSearch() throws {
        viewModel.search(by: "gg")
        XCTAssertNotEqual(viewModel.pageNumber, 2)
        XCTAssertEqual(viewModel.documents.count, 0)
    }

    func testChangeSearchType() throws {
        viewModel.changeSearchType(.all)
        XCTAssertEqual(viewModel.searchType, .all)
        XCTAssertNotEqual(viewModel.pageNumber, 2)
    }

    func testResetPageNumber() throws {
        viewModel.getNextPage()
        XCTAssertGreaterThan(viewModel.pageNumber, 1)
    }

    override func tearDown() {
        viewModel = nil
        apiService = nil
    }
}
