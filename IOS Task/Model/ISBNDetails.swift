//
//  ISBNDetails.swift
//  IOS Task
//
//  Created by fares on 05/12/2021.
//

import Foundation

struct ISBNResponse: Decodable {
    var isbn: [ISBNDetails]

    private struct DynamicCodingKeys: CodingKey {
        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var isbnArray = [ISBNDetails]()
        for key in container.allKeys {
            let decodedObject = try container.decode(ISBNDetails.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            isbnArray.append(decodedObject)
        }
        isbn = isbnArray
    }
}

// MARK: - ISBNDetails

struct ISBNDetails: Codable {
    var bibKey: String?
    var infoURL: String?
    var preview: String?
    var previewURL: String?
    var thumbnailURL: String?
    var details: Details?

    enum CodingKeys: String, CodingKey {
        case bibKey = "bib_key"
        case infoURL = "info_url"
        case preview
        case previewURL = "preview_url"
        case thumbnailURL = "thumbnail_url"
        case details
    }
}

// MARK: - Details

struct Details: Codable {
    var authors: [Author]?
    var title: String?
}

// MARK: - Author

struct Author: Codable {
    var key, name: String?
}
