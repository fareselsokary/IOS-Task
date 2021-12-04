//
//  HTTPHeader.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

/// MARK: - A representation of a single HTTP header's name / value pair.

struct HTTPHeader: Hashable {
    /// Name of the header.
    let name: String

    /// Value of the header.
    let value: String

    /// Creates an instance from the given `name` and `value`.
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

/// MARK: -  An order-preserving and case-insensitive representation of HTTP headers.

struct HTTPHeaders {
    private var headers: [HTTPHeader] = []

    /// Creates an empty instance.
    public init() {}

    /// Creates an instance from an array of `HTTPHeader`s. Duplicate case-insensitive names are collapsed into the last
    /// name and value encountered.
    public init(_ headers: [HTTPHeader]) {
        self.init()
        headers.forEach { update($0) }
    }

    /// Case-insensitively updates or appends an `HTTPHeader` into the instance using the provided `name` and `value`.
    mutating func add(name: String, value: String) {
        update(HTTPHeader(name: name, value: value))
    }

    /// Case-insensitively updates or appends the provided `HTTPHeader` into the instance.
    mutating func update(_ header: HTTPHeader) {
        guard let index = headers.firstIndex(where: { $0.name.lowercased() == header.name.lowercased() }) else {
            headers.append(header)
            return
        }

        headers.replaceSubrange(index ... index, with: [header])
    }

    var dictionary: [String: String] {
        let namesAndValues = headers.map { ($0.name, $0.value) }

        return Dictionary(namesAndValues, uniquingKeysWith: { _, last in last })
    }
}
