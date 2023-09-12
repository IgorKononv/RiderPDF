//
//  FilesViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 11.09.2023.
//

import Foundation
import UIKit

final class FilesViewController: UIViewController {
    let titleLabel = UILabel()
    let bellButton = UIButton()
    let dumbbellButton = UIButton()
    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpHeaderComponents()
        setUpSearchBar()
    }
    
    private func setUpHeaderComponents() {
        setUpTitleLabel()
        setUpBellButton()
        setUpDumbbellButton()
    }
    
    private func setUpTitleLabel() {
        titleLabel.text = "My Files"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
        ])
    }
    private func setUpBellButton() {
        bellButton.setImage(UIImage(named: "bell_icon"), for: .normal)
        bellButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bellButton)
        
        NSLayoutConstraint.activate([
            bellButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            bellButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    private func setUpDumbbellButton() {
        dumbbellButton.setImage(UIImage(named: "dots_icon"), for: .normal)
        dumbbellButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dumbbellButton)
        
        NSLayoutConstraint.activate([
            dumbbellButton.trailingAnchor.constraint(equalTo: bellButton.leadingAnchor, constant: -16.0),
            dumbbellButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
    private func setUpSearchBar() {
        
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

