//
//  AppCoordinator.swift
//  DogsApp
//
//  Created by Artur Marchetto on 30/05/2022.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    
    private let window: UIWindow
    private let mainCoordinator: MainCoordinator
    
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        
        mainCoordinator = MainCoordinator(navigationController: navigationController)
    }
    
    func start() {
        window.rootViewController = navigationController
        mainCoordinator.start()
        window.makeKeyAndVisible()
    }
}
