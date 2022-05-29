//
//  CoordinatorProtocol.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import UIKit

protocol MainCoordinatorProtocol: CoordinatorProtocol {
    func showBreedImages(breed: String)
}

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get }
    func start()
}
