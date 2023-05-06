import Foundation
import UIKit
import Kingfisher

enum urls: String {
    case initialURL = "https://pokeapi.co/api/v2/pokemon"
    case urlToStop = "https://pokeapi.co/api/v2/pokemon?offset=780&limit=20"
    case lastURL = "https://pokeapi.co/api/v2/pokemon?offset=780&limit=27"
}

class HomeViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var searchBar = UISearchBar()
    var pokemons: Pokemons?
    var pokemonArray = [Results?]()
    var pokemonArrayFiltered = [Results?]()
    var searchController: UISearchController!
    var coordinator: AppCoordinator?
    private var searchActive : Bool = false
    private var isFinalToLoad : Bool = false
    private var pokedexInteractor: PokedexInteractorProtocol?
//    private var initialURL = "https://pokeapi.co/api/v2/pokemon"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        fetchData()
    }
    
    private func setupViews() {
        setupLabel()
        setupLines()
        setupSearchBar()
        setupCollectionView()
    }
    
    private func fetchData() {
        let pokedexInteractorBuilder = PokedexInteractorBuilder()
        pokedexInteractor = pokedexInteractorBuilder.createInteractor(viewController: self)
        pokedexInteractor?.fetchData(url: urls.initialURL.rawValue)
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
        searchBar.delegate = self
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
//        let URLToStop: String = "https://pokeapi.co/api/v2/pokemon?offset=780&limit=20"
//        let lastURL: String = "https://pokeapi.co/api/v2/pokemon?offset=780&limit=27"
        if !searchActive {
            if !isFinalToLoad {
                if indexPath.item == self.pokemonArray.count - 4 && self.pokemonArray.count < (self.pokemons?.count)! {
                    if (!(self.pokemons?.next!.elementsEqual(urls.urlToStop.rawValue))!) {
                        self.pokedexInteractor?.fetchData(url: self.pokemons?.next ?? "")
                    } else {
                        self.pokedexInteractor?.fetchData(url: urls.lastURL.rawValue)
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
            let imageUrl = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")!
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
                        
        cell.backgroundColor = UIColor.lightGray
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var idToSend: Int = 0
        if searchActive {
            if let url = (self.pokemonArrayFiltered[indexPath.item]?.url) {
                idToSend = Int(url.split(separator: "/").last!)!
            }
        } else {
            if let url = (self.pokemonArray[indexPath.item]?.url) {
                idToSend = Int(url.split(separator: "/").last!)!
            }
        }
        coordinator?.showDetails(id: idToSend, controller: self)
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        return searchView
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {}
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(searchBar: searchBar, textDidChange: nil)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchBar: searchBar, textDidChange: searchText)
    }
    
    func search(searchBar: UISearchBar, textDidChange searchText: String?) {
        self.pokemonArrayFiltered.removeAll()
        if !searchBar.text!.isEmpty {
            self.searchActive = true
            self.isFinalToLoad = true
            for item in self.pokemonArray {
                if let name = item?.name!.lowercased() {
                    if ((name.contains(searchBar.text!.lowercased()))) {
                        self.pokemonArrayFiltered.append(item)
                    }
                }
                if let idToSearch = Int(searchBar.text!) {
                    if let url = item?.url!.lowercased() {
                        let id = Int(url.split(separator: "/").last!)
                        if id == idToSearch {
                            self.pokemonArrayFiltered.append(item)
                        }
                    }
                }
            }
            if (searchBar.text!.isEmpty) {
                self.pokemonArrayFiltered = self.pokemonArray
            }
        } else {
            self.searchActive = false
            self.isFinalToLoad = false
        }
        
        self.collectionView.reloadData()
        
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
}
