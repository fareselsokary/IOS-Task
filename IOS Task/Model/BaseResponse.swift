//
//  BaseResponse.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

// MARK: - BaseResponse

class BaseResponse: Codable {
    var numFound, start: Int?
    var numFoundExact: Bool?
    var docs: [Document]?

    init(numFound: Int?, start: Int?, numFoundExact: Bool?, docs: [Document]?, q: String?) {
        self.numFound = numFound
        self.start = start
        self.numFoundExact = numFoundExact
        self.docs = docs
    }
}
