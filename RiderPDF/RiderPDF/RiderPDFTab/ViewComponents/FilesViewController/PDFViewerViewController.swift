//
//  PDFViewerViewController.swift
//  RiderPDF
//
//  Created by Igor Kononov on 12.09.2023.
//

import Foundation
import UIKit
import PDFKit

final class PDFViewerViewController: UIViewController, PDFViewDelegate {
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
        guard let url = Bundle.main.url(forResource: "Igor_Kononov", withExtension: "pdf") else { return }
        guard let document = PDFDocument(url: url) else { return }
        
        pdfView.document = document
        pdfView.frame = view.bounds
        pdfView.usePageViewController(true)
        pdfView.autoScales = true
        pdfView.delegate = self
        
        setUpThumbnailView(pdfView)
    }
    
    private func setUpThumbnailView(_ pdfView: PDFView) {
        let thumbnailView = PDFThumbnailView()
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.addSubview(thumbnailView)
        thumbnailView.pdfView = pdfView
        
        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: pdfView.safeAreaLayoutGuide.leadingAnchor),
            thumbnailView.trailingAnchor.constraint(equalTo: pdfView.safeAreaLayoutGuide.trailingAnchor),
            thumbnailView.bottomAnchor.constraint(equalTo: pdfView.safeAreaLayoutGuide.bottomAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        thumbnailView.thumbnailSize = CGSize(width: 50, height: 80)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.backgroundColor = .gray

    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
