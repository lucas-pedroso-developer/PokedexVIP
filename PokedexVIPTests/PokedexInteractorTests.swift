import XCTest
@testable import PokedexVIP

enum PokedexError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
    case decodingFailed
    case genericError
}

class PokedexInteractorTests: XCTestCase {
    
    var interactor: PokedexInteractor!
    var mockPresenter: MockPokedexPresenter!
    var mockUseCase: MockPokedexUseCase!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockPokedexPresenter()
        mockUseCase = MockPokedexUseCase()
        interactor = PokedexInteractor(presenter: mockPresenter, useCase: mockUseCase)
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockUseCase = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        let url = "https://pokeapi.co/api/v2/pokemon"
        let pokemons = Pokemons(count: 0, next: "", previous: "", results: [])
        mockUseCase.result = .success(pokemons)
        interactor.fetchData(url: url)
        XCTAssertTrue(mockPresenter.fetchedSuccessDataCalled)
        XCTAssertEqual(mockPresenter.fetchedSuccessDataParameter, pokemons)
        XCTAssertFalse(mockPresenter.fetchedErrorDataCalled)
    }
    
    func testFetchDataFailure() {
        let url = "https://pokeapi.co/api/v2/pokemon"
        mockUseCase.result = .failure(PokedexError.genericError)
        interactor.fetchData(url: url)
        XCTAssertTrue(mockPresenter.fetchedErrorDataCalled)
        XCTAssertFalse(mockPresenter.fetchedSuccessDataCalled)
    }
}

class MockPokedexPresenter: PokedexPresenterProtocol {
    var fetchedSuccessDataCalled = false
    var fetchedErrorDataCalled = false
    var fetchedSuccessDataParameter: Pokemons?
    
    func fetchedSuccessData(_ data: Pokemons) {
        fetchedSuccessDataCalled = true
        fetchedSuccessDataParameter = data
    }
    
    func fetchedErrorData() {
        fetchedErrorDataCalled = true
    }
}

class MockPokedexUseCase: PokedexUseCaseProtocol {
    
    var result: Result<Pokemons, Error>!
    func execute(url: String, completion: @escaping (Result<Pokemons, Error>) -> Void) {
        completion(result)
    }
}

class SpyPokedexPresenter: PokedexPresenterProtocol {
    var fetchedSuccessDataCalled = false
    var fetchedErrorDataCalled = false
    var fetchedSuccessDataParameter: Pokemons?
    
    func fetchedSuccessData(_ data: Pokemons) {
        fetchedSuccessDataCalled = true
        fetchedSuccessDataParameter = data
    }
    
    func fetchedErrorData() {
        fetchedErrorDataCalled = true
    }
}
