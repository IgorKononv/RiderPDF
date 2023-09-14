//
//  FilesViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 11.09.2023.
//

import Foundation
import UIKit
import PDFKit

final class FilesViewController: UIViewController, PDFViewCellDelegate, OptionControllerDelegate {
    
    private let titleLabel = UILabel()
    private let bellButton = UIButton()
    private let dumbbellButton = UIButton()
    private let searchBar = UISearchBar()
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, PDFCellModel>!
    private let addButton = UIButton()

    private var sections: [PDFCellModel] = []
    private var filteredSections: [PDFCellModel] = []
    private let realmService: RealmServiceProviding = RealmServiceProvider()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpHeaderComponents()
        setUpSearchBar()
        setUpCollectionView()
        setUpAddButton()
        createDataSource()
        reloadData()
        getAllPDFFilesFomRealm()
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
        
        searchBar.delegate = self
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func setUpAddButton() {
        addButton.setBackgroundImage(UIImage(named: "add_PDF_Image"), for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addButtonTap), for: .touchUpInside)

        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0)
        ])
    }
    
    @objc private func addButtonTap(_ sender: UITapGestureRecognizer) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.adobe.pdf"], in: .import)
           documentPicker.delegate = self
           present(documentPicker, animated: true, completion: nil)
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: view.frame.width / 3 - 8, height: 200)
        
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
        snapshot.appendItems(filteredSections)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func getAllPDFFilesFomRealm() {
        for items in realmService.getAllItemsObjects() {
            sections.append(items)
            filteredSections.append(items)
        }
        reloadData()
    }
    
    func didSelectСellImage(_ item: PDFCellModel?) {
        let pdfViewerVC = PDFRidingViewController()
        pdfViewerVC.cellModel = item
        pdfViewerVC.modalPresentationStyle = .fullScreen
        self.present(pdfViewerVC, animated: true, completion: nil)
    }
    
    func didSelectСellDots(_ item: PDFCellModel?) {
        let pdfOptionsVC = PDFOptionsViewController()
        pdfOptionsVC.cellModel = item
        pdfOptionsVC.delegate = self
        pdfOptionsVC.modalPresentationStyle = .formSheet
        
        if let sheet = pdfOptionsVC.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                600.0
            }), .large()]
        }
        self.present(pdfOptionsVC, animated: true, completion: nil)
    }
    
    func deletePDF(cellModel: PDFCellModel?) {
        guard let cellModel = cellModel else { return }
        filteredSections.removeAll(where: { $0.id == cellModel.id })
        sections.removeAll(where: { $0.id == cellModel.id })

        realmService.deleteItemModel(item: cellModel)
        reloadData()
    }
}

private extension FilesViewController {
    enum Section {
        case main
    }
}


extension FilesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            if let pdfDocument = PDFDocument(url: url), let pdfPage = pdfDocument.page(at: 0) {
                let pdfPageImage = pdfPage.thumbnail(of: CGSize(width: 70, height: 100), for: .mediaBox)
                let fileName = url.lastPathComponent
                
                do {
                    let fileAttributes = try FileManager.default.attributesOfItem(atPath: url.path)
                    if let fileSize = fileAttributes[.size] as? Int64 {
                        let fileSizeString = ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file)
                        
                        if let pdfData = try? Data(contentsOf: url) {
                            
                            let newPDFFile = PDFCellModel(id: UUID().uuidString, image: pdfPageImage, name: fileName, size: fileSizeString, dateCreated: Date(), dataPDF: pdfData)
                            
                            sections.append(newPDFFile)
                            filteredSections.append(newPDFFile)
                            realmService.addNewItemModel(item: newPDFFile)
                            reloadData()
                        }
                    }
                } catch {
                    print("pdf: - \(error)")
                }
            }
        }
    }
}

extension FilesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSections = sections
        } else {
            filteredSections = sections.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        reloadData()
    }
}
