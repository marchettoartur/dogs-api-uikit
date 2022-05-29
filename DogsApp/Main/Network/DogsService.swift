//
//  DogsService.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import SwiftUI
import Combine

protocol DogsProtocol {
    var apiSession: APISessionProvider { get }
    func fetchAllBreeds() -> AnyPublisher<Breeds, Error>
    func fetchRandomImagesForBreed(name: String, count: Int) -> AnyPublisher<BreedImages, Error>
}

struct DogsService: DogsProtocol {
    
    var apiSession: APISessionProvider
    
    func fetchAllBreeds() -> AnyPublisher<Breeds, Error> {
        
        return apiSession
            .execute(Endpoints.fetchAllBreeds)
            .map { Breeds(from: $0) }
            .eraseToAnyPublisher()
    }
    
    func fetchRandomImagesForBreed(name: String, count: Int) -> AnyPublisher<BreedImages, Error> {
        
        // This could've also be implemented in a "Breed" data model class, so instead of passing just the name of the breed in this function, you could've passed a struct and then using that Breed class, you could have a computed variable that returns the breed name to be fed to the API, instead of doing it here. So it can be tested like the BreedsResponse is tested in the unit tests.
        let breedNameAPI = name
            .lowercased()
            .replacingOccurrences(of: " ", with: "/")
        
        return apiSession
            .execute(Endpoints.fetchRandomImagesForBreed(name: breedNameAPI, count: String(count)))
            .map { BreedImages(from: $0) }
            .eraseToAnyPublisher()
    }
}
