import XCTest
@testable import PokedexVIP

class HomeViewControllerTests: XCTestCase {

    var homeViewController: HomeViewController!
    
    override func setUpWithError() throws {
        homeViewController = HomeViewController()
    }

    override func tearDownWithError() throws {
        homeViewController = nil
    }
    
    func testInitialViewDidLoad() throws {
        homeViewController.viewDidLoad()
        XCTAssertTrue(self.homeViewController.view.subviews.contains(where: { $0 is UILabel }))
        XCTAssertTrue(self.homeViewController.view.subviews.contains(where: { $0 is UISearchBar }))
        XCTAssertTrue(self.homeViewController.view.subviews.contains(where: { $0 is UICollectionView }))
        XCTAssertEqual(self.homeViewController.view.backgroundColor, .white)
    }
    
    func testCollectionViewDataSource() throws {
        homeViewController.pokemonArray = [Results(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/")]
        homeViewController.pokemonArrayFiltered = [Results(name: "Pikachu", url: "https://pokeapi.co/api/v2/pokemon/1/")]
        homeViewController.pokemons = Pokemons(count: 1, next: "", previous: "", results: [])
        homeViewController.searchActive = false
        homeViewController.setupCollectionView()
        let collectionView = homeViewController.collectionView ?? UICollectionView()
        let numberOfItems = homeViewController.collectionView(collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(numberOfItems, 1)
    }
    
    func testCollectionViewDelegateFlowLayout() throws {
        // given
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        homeViewController.collectionView = collectionView
        let indexPath = IndexPath(row: 0, section: 0)
        let expectedCellSize = collectionView.frame.size.width - 50
        let cellSize = homeViewController.collectionView(collectionView, layout: layout, sizeForItemAt: indexPath)
        XCTAssertEqual(cellSize, CGSize(width: expectedCellSize/3, height: expectedCellSize/3))
    }
}

class MockPokedexInteractor: PokedexInteractorProtocol {
    
    var fetchDataClosure: (() -> Void)?
    var viewController: UIViewController?
    var isFetchDataCalled = false
    var url: String?
    
    init(fetchDataClosure: @escaping () -> Void) {
        self.fetchDataClosure = fetchDataClosure
    }
    
    func fetchData(url: String) {
        isFetchDataCalled = true
        self.url = url
        fetchDataClosure?()
    }
}

