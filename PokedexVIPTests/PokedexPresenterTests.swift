import XCTest
@testable import PokedexVIP

class PokedexPresenterTests: XCTestCase {

    var sut: PokedexPresenter!
    var mockController: MockPokedexViewController!
    
    override func setUp() {
        super.setUp()
        sut = PokedexPresenter()
        mockController = MockPokedexViewController()
        sut.controller = mockController
    }

    override func tearDown() {
        sut = nil
        mockController = nil
        super.tearDown()
    }

    func testFetchedSuccessData() {
        let testData = Pokemons(count: 0, next: "", previous: "", results: [])
        sut.fetchedSuccessData(testData)
        XCTAssertTrue(mockController.showDataCalled, "O método showData do controller não foi chamado.")
        XCTAssertEqual(mockController.showDataReceivedData, testData, "Os dados recebidos no método showData são diferentes dos dados esperados.")
    }

    func testFetchedErrorData() {
        sut.fetchedErrorData()
        XCTAssertTrue(mockController.showErrorMenuCalled, "O método showErrorMenu do controller não foi chamado.")
    }
    
}

class MockPokedexViewController: PokedexViewControllerOutput {

    var showDataCalled = false
    var showDataReceivedData: Pokemons?
    func showData(_ data: Pokemons) {
        showDataCalled = true
        showDataReceivedData = data
    }

    var showErrorMenuCalled = false
    func showErrorMenu() {
        showErrorMenuCalled = true
    }
    
}
