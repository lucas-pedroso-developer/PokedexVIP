//
//  PokedexInteractorBuilder.swift
//  PokedexVIP
//
//  Created by user on 06/05/23.
//

import Foundation
import UIKit

class PokedexInteractorBuilder {
    
    func createInteractor(viewController: PokedexViewControllerOutput) -> PokedexInteractorProtocol {
        let presenter = PokedexPresenter()
        let network = NetworkManager()
        let repository = PokedexRepository(network: network)
        let useCase = PokedexUseCase(repository: repository)
        let interactor = PokedexInteractor(presenter: presenter, useCase: useCase)
        presenter.controller = viewController
        return interactor
    }

}
