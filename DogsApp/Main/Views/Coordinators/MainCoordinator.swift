
//  MainCoordinator.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import UIKit

final class MainCoordinator: MainCoordinatorProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let rootViewController = HomeListVC()
        rootViewController.coordinator = self
        navigationController.setViewControllers([rootViewController], animated: true)
    }
    
    func showBreedImages(breed: String) {
        let breedImagesVC = DetailViewVC(breed: breed)
        navigationController.pushViewController(breedImagesVC, animated: true)
    }
}
