//
//  NetworkConstants.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

// host url for api
enum URLHost {
    static let base = "http://openlibrary.org/"
    static let cover = "https://covers.openlibrary.org/b/"
}

// url query fields
enum URLQuery: String {
    case q /// query filed to search in all types
    case title /// search by title
    case author /// search by author name
    case page /// page number
    case limit /// page size
    case bibkeys
    case format
    case jscmd
}

enum CoverImageSize: String {
    case small = "S"
    case medium = "M"
    case large = "L"
}
