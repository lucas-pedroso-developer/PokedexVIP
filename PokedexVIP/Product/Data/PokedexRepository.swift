import Foundation

public protocol PokedexRepositoryProtocol {
    func fetchData(url: String, completion: @escaping (Result<Pokemons, NetworkError>) -> Void)
}

public final class PokedexRepository {
    
    let network: NetworkManagerProtocol
    
    private let group: DispatchGroup = DispatchGroup()
    private var pokemonsData: Pokemons?
    
    public init(network: NetworkManagerProtocol) {
        self.network = network
    }
    
    private func fetchHomeDataSource(url: String) {
        group.enter()
        network.request(url: url) { [weak self] (response: Result<Pokemons, Error>) in
            switch response {
            case let .success(data):
                self?.pokemonsData = data
                fallthrough
            default:
                self?.group.leave()
            }
        }
    }
}

extension PokedexRepository: PokedexRepositoryProtocol {
    
    public func fetchData(url: String, completion: @escaping (Result<Pokemons, NetworkError>) -> Void) {
        fetchHomeDataSource(url: url)
        group.notify(queue: .main) { [weak self] in
            guard let pokemonsDataSource = self?.pokemonsData else {
                completion(.failure(.noData))
                return
            }
            let viewModel = pokemonsDataSource
            completion(.success(viewModel))
        }
    }
}
