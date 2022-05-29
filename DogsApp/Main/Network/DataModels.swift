//
//  DataModels.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import Foundation

struct Breeds: Identifiable {
    let id = UUID()
    var breeds: [String]
    let status: String
    
    init(from response: BreedsResponse) {
        self.status = response.status ?? ""
        
        var breedsList = [String]()
        
        guard let message = response.message else {
            self.breeds = []
            return
        }
        
        for (breed, strains) in message {
            
            if strains.isEmpty {
                breedsList.append(breed.capitalizingFirstLetter())
            } else {
                let strains = strains.map { "\(breed) \($0)" }
                let capitalStrains = strains.map { $0.capitalizingFirstLetter() }
                breedsList.append(contentsOf: capitalStrains)
            }
        }
        
        self.breeds = breedsList.sorted { $1 > $0 }
    }
}

struct BreedImages: Identifiable {
    let id = UUID()
    let images: [String]
    let status: String
    
    init(from response: BreedImagesResponse) {
        self.status = response.status ?? ""
        self.images = response.message ?? []
    }
}

struct BreedsResponse: Codable {
    let message: [String: [String]]?
    let status: String?
}

struct BreedImagesResponse: Codable {
    let message: [String]?
    let status: String?
}
