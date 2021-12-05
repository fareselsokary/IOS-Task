//
//  DocumentListViewModel.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Combine
import UIKit

enum SearchType: Int, CaseIterable {
    case all = 0
    case title = 1
    case author = 2

    var name: String {
        switch self {
        case .all:
            return "All"
        case .title:
            return "Title"
        case .author:
            return "Auther"
        }
    }
}

class DocumentListViewModel {
    // MARK: - Output

    @Published private(set) var documents = [Document]()

    @Published private(set) var errorMessage = ""

    @Published private(set) var isLoading = false

    @Published private(set) var searchType: SearchType = .all

    private var searchCompletionHandler: ((Subscribers.Completion<NetworkError>) -> Void)!

    private var searchValueHandler: ((BaseResponse) -> Void)!

    // MARK: - Properties

    private let apiService: DocumentListServiceType
    private var cancellables = Set<AnyCancellable>()

    init(apiService: DocumentListServiceType) {
        self.apiService = apiService
        searchCompletionHandler = { [weak self] completion in
            switch completion {
            case .finished:
                self?.isLoading = false
            case let .failure(error):
                self?.isLoading = false
                switch error {
                case .noInternet:
                    self?.errorMessage = ErrorMessages.noInternet.rawValue
                case .apiFailure:
                    self?.errorMessage = ErrorMessages.apiFailure.rawValue
                case let .invalidResponse(error):
                    self?.errorMessage = error ?? ErrorMessages.apiFailure.rawValue
                }
            }
        }

        searchValueHandler = { [weak self] response in
            self?.documents = response.docs ?? []
        }
    }

    func changeSearchType(_ type: SearchType) {
        searchType = type
    }

    // MARK: - get documents by search type

    func getDocuments(with keyWord: String) {
        switch searchType {
        case .all:
            searchInAllDocuments(keyWord: keyWord)
        case .title:
            getDcoumentsByTitle(keyWord: keyWord)
        case .author:
            getDocumentsByAuthor(keyWord: keyWord)
        }
    }

    // search in all fields by keyword entered by user
    private func searchInAllDocuments(keyWord: String) {
        isLoading = true
        apiService
            .getDocuments(keyWord: keyWord)
            .sink(receiveCompletion: searchCompletionHandler, receiveValue: searchValueHandler)
            .store(in: &cancellables)
    }

    // search in all documents by document title
    private func getDcoumentsByTitle(keyWord: String) {
        isLoading = true
        apiService
            .getDocuments(title: keyWord)
            .sink(receiveCompletion: searchCompletionHandler, receiveValue: searchValueHandler)
            .store(in: &cancellables)
    }

    // get all dcument by auther name
    private func getDocumentsByAuthor(keyWord: String) {
        isLoading = true
        apiService
            .getAutherDocuments(autherName: keyWord)
            .sink(receiveCompletion: searchCompletionHandler, receiveValue: searchValueHandler)
            .store(in: &cancellables)
    }
}
