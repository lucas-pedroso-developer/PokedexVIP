import Foundation

public final class PokedexInteractor {
    
    let presenter: PokedexPresenterProtocol
    let useCase: PokedexUseCaseProtocol
    
    public init(presenter: PokedexPresenterProtocol, useCase: PokedexUseCaseProtocol) {
        self.presenter = presenter
        self.useCase = useCase
    }
}

extension PokedexInteractor: PokedexInteractorProtocol {
    public func fetchData(url: String) {
        useCase.execute(url: url) { [weak self] result in
            switch result {
            case let .success(data): self?.presenter.fetchedSuccessData(data)
            case .failure: self?.presenter.fetchedErrorData()
            }
        }
    }
}
