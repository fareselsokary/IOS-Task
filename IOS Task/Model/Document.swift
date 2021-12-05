//
//  Document.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

// MARK: - Document

class Document: Codable {
    var title: String?
    var isbn: [String]?
    var authorName: [String]?

    enum CodingKeys: String, CodingKey {
        case title
        case isbn
        case authorName = "author_name"
    }
}
