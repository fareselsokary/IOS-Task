//
//  DocumentListService.swift
//  IOS Task
//
//  Created by fares on 04/12/2021.
//

import Combine
import Foundation

protocol DocumentListServiceType {
    func getDocuments(keyWord: String, pageNumber: String, pageSize: String) -> AnyPublisher<BaseResponse, NetworkError>
    func getAutherDocuments(autherName: String, pageNumber: String, pageSize: String) -> AnyPublisher<BaseResponse, NetworkError>
    func getDocuments(title: String, pageNumber: String, pageSize: String) -> AnyPublisher<BaseResponse, NetworkError>
}

class DocumentListService: DocumentListServiceType {
    func getDocuments(keyWord: String, pageNumber: String, pageSize: String) -> AnyPublisher<BaseResponse, NetworkError> {
        let param = [URLQuery.q.rawValue: keyWord,
                     URLQuery.page.rawValue: pageNumber,
                     URLQuery.limit.rawValue: pageSize]
        return NetworkManager.request(path: .queryItems(baseUrl: URLHost.base, endPoint: URLEndPoint.search, parameters: param),
                                      httpMethod: .get,
                                      returnType: BaseResponse.self)
    }

    func getAutherDocuments(autherName: String, pageNumber: String, pageSize: String) -> AnyPublisher<BaseResponse, NetworkError> {
        let param = [URLQuery.author.rawValue: autherName,
                     URLQuery.page.rawValue: pageNumber,
                     URLQuery.limit.rawValue: pageSize]
        return NetworkManager.request(path: .queryItems(baseUrl: URLHost.base, endPoint: URLEndPoint.search, parameters: param),
                                      httpMethod: .get,
                                      returnType: BaseResponse.self)
    }

    func getDocuments(title: String, pageNumber: String, pageSize: String) -> AnyPublisher<BaseResponse, NetworkError> {
        let param = [URLQuery.title.rawValue: title,
                     URLQuery.page.rawValue: pageNumber,
                     URLQuery.limit.rawValue: pageSize]
        return NetworkManager.request(path: .queryItems(baseUrl: URLHost.base, endPoint: URLEndPoint.search, parameters: param),
                                      httpMethod: .get,
                                      returnType: BaseResponse.self)
    }
}
