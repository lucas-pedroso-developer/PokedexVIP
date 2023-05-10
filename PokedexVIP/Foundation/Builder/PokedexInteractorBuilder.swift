import Foundation
import UIKit

class PokedexInteractorBuilder {
    public var presenter = PokedexPresenter()
    func createInteractor(viewController: PokedexViewControllerOutput) -> PokedexInteractorProtocol {
    //func createInteractor() -> PokedexInteractorProtocol {
//        let presenter = PokedexPresenter()
        let network = NetworkManager()
        let repository = PokedexRepository(network: network)
        let useCase = PokedexUseCase(repository: repository)
        let interactor = PokedexInteractor(presenter: presenter, useCase: useCase)
        //presenter.controller = viewController
        return interactor
    }

}
