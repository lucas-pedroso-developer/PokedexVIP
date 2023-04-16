import Foundation

public final class PokedexPresenter {
    public var controller: PokedexViewControllerOutput?
    
    public init() {}
}

extension PokedexPresenter: PokedexPresenterProtocol {
    public func fetchedSuccessData(_ data: Pokemons) {
        controller?.showData(data)
    }
    
    public func fetchedErrorData() {
        controller?.showErrorMenu()
    }
}
