//
//  DogsAppTests.swift
//  DogsAppTests
//
//  Created by Artur Marchetto on 30/05/2022.
//

import XCTest
import Combine
import Foundation
@testable import DogsApp

class DogsAppTests: XCTestCase {

    let dogsService = DogsService(apiSession: APISession())
    
    private var cancellables = Set<AnyCancellable>()
    
    func testBreedsDataModel() throws {
        
        let message: [String: [String]] = [
            "appenzeller": [],
            "australian": ["shepherd"]
        ]
        
        let breedsResponse = BreedsResponse(message: message, status: "success")
        
        let breeds = Breeds(from: breedsResponse)
        
        XCTAssert(breeds.breeds.contains("Appenzeller"))
        XCTAssert(breeds.breeds.contains("Australian shepherd"))
    }
    
    func testFetchAllBreeds() throws {
        
        dogsService
            .fetchAllBreeds()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in},
                receiveValue: { breedsResponse in
                    
                    guard breedsResponse.status == "success"
                    else {
                        XCTAssert(false)
                        return
                    }
                    
                    let breeds = breedsResponse.breeds
                    
                    XCTAssert(breeds.contains("Australian shepard"))
                    XCTAssert(breeds.contains("Appenzeller"))
                }
            )
            .store(in: &self.cancellables)
    }
    
    func testFetchRandomImagesForBreed() {
        
        dogsService
            .fetchRandomImagesForBreed(name: "akita", count: 10)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { _ in},
                receiveValue: { imagesResponse in
                    
                    guard imagesResponse.status == "success"
                    else {
                        XCTAssert(false)
                        return
                    }
                    
                    let images = imagesResponse.images
                    
                    XCTAssert(images.count == 10)
                }
            )
            .store(in: &self.cancellables)
    }
}
