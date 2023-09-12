//
//  PDFViewerViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 12.09.2023.
//

import Foundation
import UIKit
import PDFKit

final class PDFViewerViewController: UIViewController {
    var cellModel: PDFCellModel?
    let pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addCloseButton()
        setUpPDFView()
    }
    
    private func setUpView() {
        view.backgroundColor = .gray
        view.addSubview(pdfView)
    }
    
    private func addCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            closeButton.widthAnchor.constraint(equalToConstant: 32.0),
            closeButton.heightAnchor.constraint(equalToConstant: 32.0)
        ])
    }
    
    private func setUpPDFView() {
        pdfView.document = PDFDocument()
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
