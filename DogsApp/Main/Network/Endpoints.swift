//
//  Endpoints.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import SwiftUI

protocol RequestProviding {
    var baseURL: String { get }
    var method: String { get }
    func urlRequest() -> URLRequest
}

@frozen enum Endpoints {
    case fetchAllBreeds
    case fetchRandomImagesForBreed(name: String, count: String)
}

extension Endpoints: RequestProviding {
    
    func urlRequest() -> URLRequest {
        
        var path = ""
        
        switch self {
        case .fetchAllBreeds:
            path = "/breeds/list/all"
        case .fetchRandomImagesForBreed(let name, let count):
            path = "/breed/\(name)/images/random/\(count)"
        }
        
        guard let url = URL(string: "\(baseURL)\(path)") else {
            preconditionFailure("Invalid URL used to create URL instance")
        }
        
        var request = URLRequest(url: url)
        print("URL path is: ", url)
        
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    var method: String {
        switch self {
        case .fetchAllBreeds,
             .fetchRandomImagesForBreed:
             return "GET"
        }
    }
    
    var baseURL: String {
        return "https://dog.ceo/api"
    }
}
