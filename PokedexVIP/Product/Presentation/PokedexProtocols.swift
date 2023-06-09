import Foundation

public protocol PokedexInteractorProtocol {
    func fetchData(url: String)
}

public protocol PokedexPresenterProtocol {
    func fetchedSuccessData(_ data: Pokemons)
    func fetchedErrorData()
}

public protocol PokedexViewControllerOutput: AnyObject {
    func showData(_ data: Pokemons)
    func showErrorMenu()
}
