//
//  APISession.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import SwiftUI
import Combine

typealias DataTaskResult = (data: Data, response: URLResponse)

protocol APISessionProvider {
    func execute<Output: Decodable>(_ requestProvider: RequestProviding) -> AnyPublisher<Output, Error>
}

struct APISession: APISessionProvider {
    
    func execute<Output>(_ requestProvider: RequestProviding)
    -> AnyPublisher<Output, Error>
    where Output: Decodable {
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForResource = 20
        let request = requestProvider.urlRequest()
        
        return URLSession(configuration: config)
            .dataTaskPublisher(for: request)
            .retry(2)
            .mapJSONResult(to: Output.self, using: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == DataTaskResult {
    
    func mapJSONResult<Output: Decodable>(to outputType: Output.Type, using decoder: JSONDecoder) -> AnyPublisher<Output, Error> {
        return self
            .map {
                if $0.data.isEmpty {
                    return "{}".data(using: .utf8) ?? $0.data
                } else {
                    return $0.data
                }
            }
            .decode(type: outputType, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
