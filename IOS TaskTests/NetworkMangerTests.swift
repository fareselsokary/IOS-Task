//
//  NetworkMangerTests.swift
//  IOS TaskTests
//
//  Created by fares on 05/12/2021.
//

import Combine
@testable import IOS_Task
import XCTest

class NetworkMangerTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testAPIRequest() throws {
        // this is the URL we expect to call
        let url = "https://www.apple.com/newsroom/rss-feed.rss"

        let request: AnyPublisher<BaseResponse, NetworkError> = APIRequestManager.shared.request(path: url,
                                                                                                 httpMethod: .get,
                                                                                                 parameters: nil,
                                                                                                 headers: nil)

        request.sink { [weak self] completion in
            switch completion {
            case .finished:
                self?.expectation(description: "Expected finish call request successfuly").fulfill()
            case let .failure(error):
                XCTFail("expexted to fail with" + error.localizedDescription)
            }
        } receiveValue: { [weak self] response in
            if response.docs?.isEmpty == true {
                self?.expectation(description: "Expected finish call request failure").fulfill()
            } else {
                self?.expectation(description: "Expected finish call request successfuly").fulfill()
            }

        }.store(in: &cancellables)
    }
}
