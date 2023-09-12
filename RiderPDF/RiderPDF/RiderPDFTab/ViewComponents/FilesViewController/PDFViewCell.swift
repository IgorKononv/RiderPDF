//
//  PDFViewCell.swift
//  RiderPDF
//
//  Created by Igor Kononov on 12.09.2023.
//

import Foundation
import UIKit

protocol PDFViewCellDelegate: AnyObject{
    func didSelectСellImage(_ item: PDFCellModel?)
    func didSelectСellDots(_ item: PDFCellModel?)
}

final class PDFViewCell: UICollectionViewCell {
    
    static let cellID = "reuseIdentifier_PDFViewCell"
    
    var cellModel: PDFCellModel?
    weak var delegate: PDFViewCellDelegate?

    private let imageButton = UIButton()
    private let cellLabel = UILabel()
    private let fileSizeLabel = UILabel()
    private let dotsButton = UIButton()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpCell() {
        setUpImageButton()
        setUpCellLabel()
        setUpFileSizeLabel()
        setUpFileDotsButton()
    }
    
    private func setUpImageButton() {
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageButton)
        imageButton.imageView?.contentMode = .scaleAspectFit
        imageButton.addTarget(self, action: #selector(self.buttonImageTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            imageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            imageButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func setUpCellLabel() {
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.textAlignment = .center
        addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellLabel.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 5),
            cellLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            cellLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    private func setUpFileSizeLabel() {
        fileSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        fileSizeLabel.textAlignment = .center
        addSubview(fileSizeLabel)
        
        NSLayoutConstraint.activate([
            fileSizeLabel.topAnchor.constraint(equalTo: cellLabel.bottomAnchor, constant: 5),
            fileSizeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            fileSizeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    private func setUpFileDotsButton() {
        dotsButton.translatesAutoresizingMaskIntoConstraints = false
        dotsButton.setImage(UIImage(named: "dots_in_cell_icon"), for: .normal)
        addSubview(dotsButton)
        dotsButton.addTarget(self, action: #selector(self.buttonDotsTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            dotsButton.topAnchor.constraint(equalTo: fileSizeLabel.bottomAnchor, constant: 5),
            dotsButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            dotsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func comonInit(item: PDFCellModel) {
        cellModel = item
        cellLabel.text = item.name
        fileSizeLabel.text = item.size
        imageButton.setBackgroundImage(UIImage(systemName: cellModel?.image ?? ""), for: .normal)
    }
    
    @objc private func buttonDotsTapped(_ sender: UIButton) {
        delegate?.didSelectСellDots(cellModel)
    }
    
    @objc private func buttonImageTapped(_ sender: UIButton) {
        delegate?.didSelectСellImage(cellModel)
    }
}
