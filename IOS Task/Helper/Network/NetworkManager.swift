//
//  NetworkManager.swift
//  IOS Task
//
//  Created by fares on 03/12/2021.
//

import Combine
import Foundation

// MARK: - Custom Error enum that we'll use in case

enum NetworkError: Error {
    case noInternet
    case apiFailure
    case invalidResponse(_ error: String?)
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
    func makeRequest<T: Codable>(session: URLSession, request: URLRequest) -> AnyPublisher<T, NetworkError>
    func request<T: Codable>(path: String, httpMethod: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> AnyPublisher<T, NetworkError>
}

fileprivate class APIRequestManager: APIRequestProtocol {
    // create single entry for APIRequestManager
    static let shared = APIRequestManager()

    // make init privarte to prevent any other instance from APIRequestManager
    private init() {}
}

extension APIRequestManager {
    // This function calls the URLRequest passed to it, maps the result and returns it
    fileprivate func makeRequest<T: Codable>(session: URLSession, request: URLRequest) -> AnyPublisher<T, NetworkError> {
        return session.dataTaskPublisher(for: request)
            .tryMap { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                NetworkError.invalidResponse(error.localizedDescription)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension APIRequestManager {
    // create URLRequest then call 'makeRequest' to make api using URLSession
    fileprivate func request<T: Codable>(path: String, httpMethod: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?) -> AnyPublisher<T, NetworkError> {
        // check if url is valid else return invalid url state
        guard let url = URL(string: path) else {
            return AnyPublisher(Fail<T, NetworkError>(error: .apiFailure))
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
        if let parms = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parms)
                // add request http body data
                request.httpBody = jsonData
            } catch {
                return AnyPublisher(Fail<T, NetworkError>(error: .invalidResponse(error.localizedDescription)))
            }
        }
        // create URLSession request
        return makeRequest(session: session, request: request)
    }
}

class NetworkManager {
    static func request<T>(path: URLEncoding, httpMethod: HTTPMethod, returnType: T.Type, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> AnyPublisher<T, NetworkError> where T: Codable {
        if Reachability.isConnectedToNetwork() {
            return APIRequestManager.shared.request(path: path.value, httpMethod: httpMethod, parameters: parameters, headers: headers)
        } else {
            return AnyPublisher(Fail<T, NetworkError>(error: .noInternet))
        }
    }
}
