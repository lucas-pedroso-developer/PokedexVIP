import XCTest
@testable import PokedexVIP

class PokedexRepositoryTests: XCTestCase {
    
    var sut: PokedexRepository!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        sut = PokedexRepository(network: mockNetworkManager)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func test_fetchData_success() {
        let expectation = XCTestExpectation(description: "Completion wasn't called")
        
        sut.fetchData(url: "") { result in
            switch result {
            case let .success(data):
                XCTAssertEqual(data.count, 10)
                expectation.fulfill()
            case .failure:
                XCTFail("Should have succeeded")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

class MockNetworkManager: NetworkManagerProtocol {
    func request<T>(url: String, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let data = Pokemons(count: 10, next: "", previous: "", results: [])
        completion(.success(data as! T))
    }
}
