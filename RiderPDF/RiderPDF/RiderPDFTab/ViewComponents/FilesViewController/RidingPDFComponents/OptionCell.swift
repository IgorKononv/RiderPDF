//
//  OptionCell.swift
//  RiderPDF
//
//  Created by Igor Kononov on 13.09.2023.
//

import Foundation
import UIKit

final class OptionCell: UITableViewCell {
    var option: PDFOptionsModel?

    private let image = UIImageView()
    private let name = UILabel()
    
    private let stackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(image)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(option: PDFOptionsModel) {
        self.option = option
        image.image = UIImage(named: option.image)
        name.text = option.name
    }
}
