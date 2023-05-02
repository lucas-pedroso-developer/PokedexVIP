import Foundation
import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var pokemons: Pokemons?
    var pokemonArray = [Results?]()
    var pokemonArrayFiltered = [Results?]()
    var searchController: UISearchController!
    var searchActive : Bool = false
    var isFinalToLoad : Bool = false
    let URLToStop: String = "https://pokeapi.co/api/v2/pokemon?offset=780&limit=20"
    let lastURL: String = "https://pokeapi.co/api/v2/pokemon?offset=780&limit=27"
    public var get: ((_ url: String) -> Void?)?
    var pokedexInteractor: PokedexInteractorProtocol?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLabel()
        setupLines()
        setupSearchBar()
        setupCollectionView()
        fetchData()
    }
    
    private func fetchData() {
        self.pokedexInteractor = createInteractor()
        self.pokedexInteractor?.fetchData()
    }
    
    func createInteractor() -> PokedexInteractorProtocol {
        let presenter = PokedexPresenter()
        let network = NetworkManager()
        let repository = PokedexRepository(network: network)
        let useCase = PokedexUseCase(repository: repository)
        let interactor = PokedexInteractor(presenter: presenter, useCase: useCase)
        presenter.controller = self
        return interactor
    }
    
    private func setupLabel() {
        let label = UILabel()
        label.text = "Pokedex"
        label.textColor = .black
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupLines() {
        let uiView = UIView()
        uiView.backgroundColor = .lightGray
        view.addSubview(uiView)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        uiView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uiView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        uiView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
        
        let uiView2 = UIView()
        uiView2.backgroundColor = .lightGray
        view.addSubview(uiView2)
        uiView2.translatesAutoresizingMaskIntoConstraints = false
        uiView2.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        uiView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        uiView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        uiView2.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width).isActive = true
    }
    
    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .red
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(PokemonsCollectionViewCell.self, forCellWithReuseIdentifier: "PokemonsCollectionViewCell")
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        view.addSubview(collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return self.pokemonArrayFiltered.count
        } else if self.pokemons?.results != nil {
            return self.pokemonArray.count
        }
        return 0
    }
        
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !searchActive {
            if !isFinalToLoad {
                if indexPath.item == self.pokemonArray.count - 4 && self.pokemonArray.count < (self.pokemons?.count)! {
                    if (!(self.pokemons?.next!.elementsEqual(self.URLToStop))!) {
                        get?((self.pokemons?.next!)!)
                    } else {
                        get?(self.lastURL)
                        self.isFinalToLoad = true
                    }
                }
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "PokemonsCollectionViewCell", for: indexPath as IndexPath) as!  PokemonsCollectionViewCell
        if searchActive {
            cell.label.text = self.pokemonArrayFiltered[indexPath.item]?.name
            let url = (self.pokemonArrayFiltered[indexPath.item]?.url)!
            let id = String(format: "%03d", Int(url.split(separator: "/").last!)!)
            let imageUrl = URL(string: "https://assets.pokemon.com/assets/cms2/img/pokedex/full/\(id).png")!
            cell.imageView.kf.setImage(with: imageUrl)
        } else {
            if let name = self.pokemonArray[indexPath.item]?.name {
                cell.label.text = name
            }
            if let url = self.pokemonArray[indexPath.item]?.url {
                let idStr = String(format: "%03d", Int(url.split(separator: "/").last!)!)
                let id = idStr.removeLeadingZeros
                let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
                cell.imageView.kf.setImage(with: imageUrl)
            }
        }
                        
        cell.backgroundColor = UIColor.cyan
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }
    
}


class PokemonsCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor)
        ])
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 20),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: PokedexViewControllerOutput {
    func showData(_ data: Pokemons) {
        self.pokemons = data
        self.pokemonArray.append(contentsOf: (data.results)!)
        self.collectionView.reloadData()
    }

    func showErrorMenu() {
        print("Cenário de erro")
    }

}

extension String {
    var removeLeadingZeros: String {
        return self.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }
}
