//
//  Coordinator.swift
//  PokedexVIP
//
//  Created by user on 05/05/23.
//

import Foundation
import UIKit

protocol Coordinator {
    func start()
}

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = HomeViewController()
        viewController.coordinator = self
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
    
    func showDetails(id: Int, controller: UIViewController) {
        let viewController = DetailViewController()
        viewController.coordinator = self
        viewController.modalPresentationStyle = .fullScreen
        viewController.id = id
        controller.present(viewController, animated: true)
    }
}
