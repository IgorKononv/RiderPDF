//
//  PDFOptionsViewContriller.swift
//  RiderPDF
//
//  Created by Igor Kononov on 13.09.2023.
//

import Foundation
import UIKit
protocol OptionControllerDelegate: AnyObject {
    func deletePDF(cellModel: PDFCellModel?)
}

final class PDFOptionsViewController: UIViewController {
    
    weak var delegate: OptionControllerDelegate?

    private let rectangleView = UIView()
    private let largeRectangleView = UIView()

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let sizeLabel = UILabel()
    private var tableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<PDFOptionsSectorsModel, PDFOptionsModel>!
    
    private var sections: [PDFOptionsSectorsModel] = []

    var cellModel: PDFCellModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpRectangle()
        addImage()
        addTitleLabel()
        addSizeLabel()
        setUpLargeRectangle()
        setUpTableView()
        createDataSource()
        reloadData()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
    }
    
    private func setUpTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OptionCell.self, forCellReuseIdentifier: "OptionCell")
        
        tableView.delegate = self
        createDataSource()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: largeRectangleView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    private func setUpRectangle() {
        rectangleView.translatesAutoresizingMaskIntoConstraints = false
        rectangleView.backgroundColor = .systemGray3
        rectangleView.layer.cornerRadius = 5
        
        view.addSubview(rectangleView)
        
        NSLayoutConstraint.activate([
            rectangleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            rectangleView.widthAnchor.constraint(equalToConstant: 110),
            rectangleView.heightAnchor.constraint(equalToConstant: 5),
            rectangleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addImage() {
        guard let cellModel = cellModel else { return }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = cellModel.image
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func addTitleLabel() {
        guard let cellModel = cellModel else { return }
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = cellModel.name
        
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: rectangleView.bottomAnchor, constant: 30)
        ])
    }
    
    private func addSizeLabel() {
        
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.text = formatDateAndSize()
        sizeLabel.textColor = UIColor.gray
        sizeLabel.font = UIFont.systemFont(ofSize: 15)
        
        view.addSubview(sizeLabel)
        
        NSLayoutConstraint.activate([
            sizeLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 20),
            sizeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
        ])
    }
    
    private func formatDateAndSize() -> String {
        guard let cellModel = cellModel else { return ""}

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        let formattedDate = dateFormatter.string(from: cellModel.dateCreated)

        return formattedDate + " • " + cellModel.size
    }
    
    private func setUpLargeRectangle() {
        largeRectangleView.translatesAutoresizingMaskIntoConstraints = false
        largeRectangleView.backgroundColor = .systemGray5
        
        view.addSubview(largeRectangleView)
        
        NSLayoutConstraint.activate([
            largeRectangleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            largeRectangleView.widthAnchor.constraint(equalToConstant: view.frame.width - 10),
            largeRectangleView.heightAnchor.constraint(equalToConstant: 1),
            largeRectangleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func createDataSource() {
        dataSource = UITableViewDiffableDataSource<PDFOptionsSectorsModel, PDFOptionsModel>(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath) as! OptionCell
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let options = section.options
            let option = options[indexPath.row]
            cell.configure(option: option)
            return cell
        }
        
        dataSource.defaultRowAnimation = .fade
    }

    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<PDFOptionsSectorsModel, PDFOptionsModel>()
        
        snapshot.appendSections([.firstSector, .secondSector])
        
        snapshot.appendItems([.edit, .sign, .convert], toSection: .firstSector)
        
        snapshot.appendItems([.share, .saveOnDevice, .saveInCloud, .rename, .delete], toSection: .secondSector)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PDFOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let option = dataSource.itemIdentifier(for: indexPath) {
            switch option {
            case .edit:
                print("Edit")
            case .sign:
                print("Sign")
            case .convert:
                print("Convert")
            case .share:
                print("Share")
            case .saveOnDevice:
                print("Save on Device")
            case .saveInCloud:
                print("Save in Cloud")
            case .rename:
                print("Rename")
            case .delete:
                let alertController = UIAlertController(title: "Remove PDF", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
                
                let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                    self.delegate?.deletePDF(cellModel: self.cellModel)
                    self.dismiss(animated: true)
                }
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}
