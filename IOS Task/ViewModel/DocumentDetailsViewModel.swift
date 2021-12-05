//
//  DocumentDetailsViewModel.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Combine

class DocumentDetailsViewModel {
    // MARK: - Output

    @Published private(set) var isbn = [ISBNDetails]()

    @Published private(set) var errorMessage = ""

    @Published private(set) var isLoading = false

    private var isbnCompletionHandler: ((Subscribers.Completion<NetworkError>) -> Void)!

    private var isbnValueHandler: ((ISBNResponse) -> Void)!

    // MARK: - Properties

    private let apiService: DocumentDetailsServiceType
    private var cancellables = Set<AnyCancellable>()

    init(apiService: DocumentDetailsServiceType) {
        self.apiService = apiService
        isbnCompletionHandler = { [weak self] completion in
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

        isbnValueHandler = { [weak self] response in
            self?.isbn = response.isbn
        }
    }

    // MARK: - get first 5 ISBN for documents

    func getISBN(_ isbns: [String]) {
        // show loader in screen
        isLoading = true
        // get first five element from isbn array
        let firstFiveElementInISBNArray = Array(isbns.prefix(5))
        apiService
            .getISBN(isbn: firstFiveElementInISBNArray)
            .sink(receiveCompletion: isbnCompletionHandler, receiveValue: isbnValueHandler)
            .store(in: &cancellables)
    }
}
