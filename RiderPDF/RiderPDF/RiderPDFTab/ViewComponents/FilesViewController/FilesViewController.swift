//
//  FilesViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 11.09.2023.
//

import Foundation
import UIKit

final class FilesViewController: UIViewController, PDFViewCellDelegate {
    
    
    private let titleLabel = UILabel()
    private let bellButton = UIButton()
    private let dumbbellButton = UIButton()
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, PDFCellModel>!

    private var sections = [PDFCellModel(image: "square.and.arrow.up", name: "first", size: "10 mb."),
                    PDFCellModel(image: "square.and.arrow.up", name: "second", size: "20 mb."),
                    PDFCellModel(image: "square.and.arrow.up", name: "third", size: "30 mb.")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpHeaderComponents()
        setUpSearchBar()
        setUpCollectionView()
        createDataSource()
        reloadData()

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
        searchBar.searchBarStyle = .minimal
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
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width / 3 - 8, height: 155)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.register(PDFViewCell.self, forCellWithReuseIdentifier: PDFViewCell.cellID)
    }
    
    
    private func createDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item  in
            switch Section.self {
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PDFViewCell.cellID, for: indexPath) as! PDFViewCell
                cell.delegate = self 
                cell.comonInit(item: item)
                return cell
            }
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, PDFCellModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(sections)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func didSelectСellImage(_ item: PDFCellModel?) {
        let pdfViewerVC = PDFViewerViewController()
        pdfViewerVC.cellModel = item
        pdfViewerVC.modalPresentationStyle = .fullScreen
        self.present(pdfViewerVC, animated: true, completion: nil)
    }
    
    func didSelectСellDots(_ item: PDFCellModel?) {
        let pdfViewerVC = PDFViewerViewController()
        pdfViewerVC.cellModel = item
        pdfViewerVC.modalPresentationStyle = .fullScreen
        self.present(pdfViewerVC, animated: true, completion: nil)
    }
}

private extension FilesViewController {
    enum Section {
        case main
    }
}
