//
//  NetworkManager.swift
//  IOS Task
//
//  Created by fares on 03/12/2021.
//

import Foundation

// MARK: - Custom Error enum that we'll use in case

enum NetworkError: Error {
    case noInternet
    case apiFailure(error: String?)
    case invalidResponse
    case invalidURL
    case decodingError(error: String?)
}

// MARK: - An enum for various HTTPMethod. I've implemented GET and POST. I'll update the code and add the rest shortly :D

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

// MARK: - to provide data to the API Calls

typealias Parameters = [String: Any]

// MARK: - protocol contain all API request methods

fileprivate protocol APIRequestProtocol {
    static func makeRequest<T: Codable>(session: URLSession, request: URLRequest, model: T.Type, onCompletion: @escaping (Result<T, NetworkError>) -> Void)
    static func request<T: Codable>(path: String, httpMethod: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, onCompletion: @escaping (Result<T, NetworkError>) -> Void)
    static func parseResponse<T>(data: Data?, onCompletion: @escaping (Result<T, NetworkError>) -> Void) where T: Codable
}

fileprivate enum APIRequestManager: APIRequestProtocol {
    // This function calls the URLRequest passed to it, maps the result and returns it
    fileprivate static func makeRequest<T: Codable>(session: URLSession, request: URLRequest, model: T.Type, onCompletion: @escaping (Result<T, NetworkError>) -> Void) {
        session.dataTask(with: request) { data, _, error in
            if error != nil && data != nil {
                parseResponse(data: data, onCompletion: onCompletion)
                return
            } else if error != nil {
                onCompletion(.failure(.apiFailure(error: error?.localizedDescription)))
                return
            } else {
                parseResponse(data: data, onCompletion: onCompletion)
                return
            }

        }.resume()
    }

    // create URLRequest then call 'makeRequest' to make api using URLSession
    static func request<T>(path: String, httpMethod: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, onCompletion: @escaping (Result<T, NetworkError>) -> Void) where T: Codable {
        // check if url is valid else return invalid url state
        guard let url = URL(string: path) else {
            return onCompletion(.failure(.invalidURL))
        }

        // get instance from URLSession
        let session = URLSession.shared

        // create URLRequest instance
        var request = URLRequest(url: url)

        // add all http header fields to request
        request.allHTTPHeaderFields = headers?.dictionary

        // add request http method
        request.httpMethod = httpMethod.rawValue

        // convert request parameters from dictionary to data
        if let parms = parameters,
           let jsonData = try? JSONSerialization.data(withJSONObject: parms) {
            // add request http body data
            request.httpBody = jsonData
        }
        // create URLSession request
        makeRequest(session: session, request: request, model: T.self, onCompletion: onCompletion)
    }
}

extension APIRequestManager {
    fileprivate static func parseResponse<T>(data: Data?, onCompletion: @escaping (Result<T, NetworkError>) -> Void) where T: Codable {
        if let responseData = data {
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    as? Parameters {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(T.self, from: jsonData)
                    onCompletion(.success(response))

                    // if the response is an `Array of Objects`
                } else if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                    as? [Parameters] {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let response = try JSONDecoder().decode(T.self, from: jsonData)
                    onCompletion(.success(response))
                } else {
                    onCompletion(.failure(NetworkError.invalidResponse))
                    return
                }
            } catch {
                onCompletion(.failure(NetworkError.decodingError(error: error.localizedDescription)))
                return
            }
        }
    }
}

class NetworkManager {
    static func request<T>(path: URLEncoding, httpMethod: HTTPMethod, returnType: T.Type, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, onCompletion: @escaping (Result<T, NetworkError>) -> Void) where T: Codable {
        if Reachability.isConnectedToNetwork() {
            APIRequestManager.request(path: path.value, httpMethod: httpMethod, parameters: parameters, headers: headers, onCompletion: onCompletion)
        } else {
            onCompletion(.failure(.noInternet))
        }
    }
}
