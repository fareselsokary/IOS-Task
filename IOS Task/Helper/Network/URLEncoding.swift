//
//  URLEncoding.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Foundation

enum URLEncoding {
    case queryItems(baseUrl: String, endPoint: String, parameters: [String: String]? = nil)
    case arguments(baseUrl: String, endPoint: String, arguments: [String])

    var value: String {
        switch self {
        case let .queryItems(baseUrl, endPoint, parameters):
            let urlString = "\(baseUrl)\(endPoint)"
            var components = URLComponents()
            components.path = urlString
            components.queryItems = []
            if let params = parameters {
                for key in params.keys {
                    components.queryItems?.append(URLQueryItem(name: key, value: params[key]!))
                }
                return (components.url?.absoluteString.removingPercentEncoding?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString)
            }
            return urlString
        case let .arguments(baseUrl, endPoint, arguments):
            let urlString = "\(baseUrl)\(endPoint)"
            let fullUrl = String(format: urlString, arguments: arguments)
            return fullUrl
        }
    }
}
