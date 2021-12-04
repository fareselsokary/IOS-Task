//
//  NetworkConstants.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

// API endpoints
enum URLEndPoint {
    static let search = "search.json"
    static let isbn = "isbn/0726913952-.jpg"
}

// host url for api
enum URLHost {
    static let base = "http://openlibrary.org/"
    static let cover = "https://covers.openlibrary.org/b/"
}

// url query fields
enum URLQuery: String {
    case q // query filed to search in all types
    case title // search by title
    case author // search by author name
    case page // page number
    case limit // page size
}
