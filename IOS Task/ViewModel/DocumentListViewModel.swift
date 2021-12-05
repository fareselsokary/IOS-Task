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

    @Published private(set) var searchWord = ""

    // MARK: - Properties

    private var searchCompletionHandler: ((Subscribers.Completion<NetworkError>) -> Void)!

    private var searchValueHandler: ((BaseResponse) -> Void)!

    private let pageSize = 10
    private var pageNumber = 1
    private var isLastPage = false
    private var isStillLoadingRequest = false

    private let apiService: DocumentListServiceType
    private var cancellables = Set<AnyCancellable>()

    // MARK: - init

    init(apiService: DocumentListServiceType) {
        self.apiService = apiService
        searchCompletionHandler = { [weak self] completion in
            switch completion {
            case .finished:
                self?.isLoading = false
            case let .failure(error):
                self?.isLoading = false
                self?.isStillLoadingRequest = false
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
            self?.isStillLoadingRequest = false
            self?.documents.append(contentsOf: response.docs ?? [])
            self?.isLastPage = self?.documents.count == response.numFound
        }

        $searchWord
            .sink { error in
                print(error)
            } receiveValue: { [weak self] keyWord in
                guard !keyWord.isBlank else { return }
                self?.resetPageNumber()
                self?.getDocuments(with: keyWord)
                self?.resetDocumentArray()
            }.store(in: &cancellables)
    }

    // MARK: - public methods

    /// change current search type
    func changeSearchType(_ type: SearchType) {
        searchType = type
        guard !searchWord.isBlank else { return }
        resetPageNumber()
        getDocuments(with: searchWord)
        resetDocumentArray()
    }

    /// change search word
    func search(by keyWord: String) {
        searchWord = keyWord
        resetPageNumber()
    }

    /// get next page if search type is all document
    func getNextPage() {
        guard !isLastPage else { return }
        pageNumber += 1
        getDocuments(with: searchWord)
    }

    // MARK: - private methods

    /// rest page number to 1
    private func resetPageNumber() {
        pageNumber = 1
        isLastPage = false
    }

    // remove all element from array
    private func resetDocumentArray() {
        documents.removeAll()
    }

    /// get documents by search type
    private func getDocuments(with keyWord: String) {
        guard !isStillLoadingRequest else { return }
        isStillLoadingRequest = true
        isLoading = pageNumber == 1
        switch searchType {
        case .all:
            searchInAllDocuments(keyWord: keyWord)
        case .title:
            getDcoumentsByTitle(keyWord: keyWord)
        case .author:
            getDocumentsByAuthor(keyWord: keyWord)
        }
    }

    /// search in all fields by keyword entered by user
    private func searchInAllDocuments(keyWord: String) {
        apiService
            .getDocuments(keyWord: keyWord, pageNumber: "\(pageNumber)", pageSize: "\(pageSize)")
            .sink(receiveCompletion: searchCompletionHandler, receiveValue: searchValueHandler)
            .store(in: &cancellables)
    }

    /// search in all documents by document title
    private func getDcoumentsByTitle(keyWord: String) {
        apiService
            .getDocuments(title: keyWord, pageNumber: "\(pageNumber)", pageSize: "\(pageSize)")
            .sink(receiveCompletion: searchCompletionHandler, receiveValue: searchValueHandler)
            .store(in: &cancellables)
    }

    /// get all dcument by auther name
    private func getDocumentsByAuthor(keyWord: String) {
        apiService
            .getAutherDocuments(autherName: keyWord, pageNumber: "\(pageNumber)", pageSize: "\(pageSize)")
            .sink(receiveCompletion: searchCompletionHandler, receiveValue: searchValueHandler)
            .store(in: &cancellables)
    }
}
