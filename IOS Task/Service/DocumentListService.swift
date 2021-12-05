//
//  DocumentListService.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Combine
import Foundation

protocol DocumentListServiceType {
    func getDocuments(keyWord: String) -> AnyPublisher<BaseResponse, NetworkError>
    func getAutherDocuments(autherName: String) -> AnyPublisher<BaseResponse, NetworkError>
    func getDocuments(title: String) -> AnyPublisher<BaseResponse, NetworkError>
}

class DocumentListService: DocumentListServiceType {
    func getDocuments(keyWord: String) -> AnyPublisher<BaseResponse, NetworkError> {
        let param = [URLQuery.q.rawValue: keyWord]
        return NetworkManager.request(path: .queryItems(baseUrl: URLHost.base, endPoint: URLEndPoint.search, parameters: param),
                                      httpMethod: .get,
                                      returnType: BaseResponse.self)
    }

    func getAutherDocuments(autherName: String) -> AnyPublisher<BaseResponse, NetworkError> {
        let param = [URLQuery.author.rawValue: autherName]
        return NetworkManager.request(path: .queryItems(baseUrl: URLHost.base, endPoint: URLEndPoint.search, parameters: param),
                                      httpMethod: .get,
                                      returnType: BaseResponse.self)
    }

    func getDocuments(title: String) -> AnyPublisher<BaseResponse, NetworkError> {
        let param = [URLQuery.title.rawValue: title]
        return NetworkManager.request(path: .queryItems(baseUrl: URLHost.base, endPoint: URLEndPoint.search, parameters: param),
                                      httpMethod: .get,
                                      returnType: BaseResponse.self)
    }
}
