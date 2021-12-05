//
//  URLEndPoint.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

// API endpoints
enum URLEndPoint {
    static let search = "search.json"
    static let isbn = "id/%@-%@.jpg?default=false"
    static let books = "api/books"
}

extension URLEndPoint {
    static func getImageUrlString(isbnNumber: String, imageSize: CoverImageSize) -> String {
        return URLEncoding.arguments(baseUrl: URLHost.base, endPoint: isbn, arguments: [isbn, imageSize.rawValue]).value
    }
}
