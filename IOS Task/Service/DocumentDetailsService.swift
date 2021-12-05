//
//  DocumentDetailsService.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Combine
import Foundation

protocol DocumentDetailsServiceType {
    func getISBN(isbn: [String]) -> AnyPublisher<ISBNResponse, NetworkError>
}

class DocumentDetailsService: DocumentDetailsServiceType {
    func getISBN(isbn: [String]) -> AnyPublisher<ISBNResponse, NetworkError> {
        let isbnBibkeys = isbn.map({ "ISBN:" + $0 }).joined(separator: ",")
        let param = [URLQuery.bibkeys.rawValue: isbnBibkeys,
                     URLQuery.format.rawValue: "json",
                     URLQuery.jscmd.rawValue: "details"]
        return NetworkManager.request(path: .queryItems(baseUrl: URLHost.base, endPoint: URLEndPoint.books, parameters: param),
                                      httpMethod: .get,
                                      returnType: ISBNResponse.self)
    }
}
