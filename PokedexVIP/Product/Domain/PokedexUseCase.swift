import Foundation

public protocol PokedexUseCaseProtocol {
    func execute(url: String, completion: @escaping (Result<Pokemons, Error>) -> Void)
}

public final class PokedexUseCase {
    private let repository: PokedexRepositoryProtocol

    public init(repository: PokedexRepositoryProtocol) {
        self.repository = repository
    }
}

extension PokedexUseCase: PokedexUseCaseProtocol { 
    public func execute(url: String, completion: @escaping (Result<Pokemons, Error>) -> Void) {
        repository.fetchData(url: url) { result in
            switch result {
            case let .success(data): completion(.success(data))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
