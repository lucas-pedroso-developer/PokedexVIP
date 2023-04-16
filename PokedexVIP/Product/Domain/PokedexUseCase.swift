import Foundation

public protocol PokedexCaseProtocol {
    func execute(completion: @escaping (Result<Pokemons, Error>) -> Void)
}

public final class PokedexUseCase {
    private let repository: PokedexRepositoryProtocol

    public init(repository: PokedexRepositoryProtocol) {
        self.repository = repository
    }
}

extension PokedexUseCase: PokedexCaseProtocol { 
    public func execute(completion: @escaping (Result<Pokemons, Error>) -> Void) {
        repository.fetchData { result in
            switch result {
            case let .success(data): completion(.success(data))
            case let .failure(error): completion(.failure(error))
            }
        }
    }
}
