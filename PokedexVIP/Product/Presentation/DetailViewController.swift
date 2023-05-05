//
//  DetailViewController.swift
//  PokedexVIP
//
//  Created by user on 04/05/23.
//

import Foundation
import UIKit

public final class DetailViewController: UIViewController {
    
    var id: Int = 0
    var coordinator: AppCoordinator?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLabel()
        setupLines()
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
    }
    
}
