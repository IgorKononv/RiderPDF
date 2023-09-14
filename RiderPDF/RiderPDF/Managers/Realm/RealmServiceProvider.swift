//
//  RealmServiceProvider.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import Foundation
import RealmSwift
import PDFKit

protocol RealmServiceProviding {
    func getAllItemsObjects() -> [PDFCellModel]
    func getItemWithID(id: String) -> PDFCellModel?
    func addNewItemModel(item: PDFCellModel)
    func deleteItemModel(item: PDFCellModel)
}

final class RealmServiceProvider: RealmServiceProviding {
    
    private let realmService = RealmService.shared
    
    private func getAllRealmServiceObjects<T: Object>() -> [T] {
        return Array(realmService.readAll(T.self))
    }
    
    //MARK: Items
    
    private func getAllRealmObjects() -> [RealmItemsModel] {
        return getAllRealmServiceObjects()
    }
    
    private func getRealmItemWithID(id: String) -> RealmItemsModel? {
        return getAllRealmObjects().first(where: {$0.id == id}) ?? nil
    }
    
    func getAllItemsObjects() -> [PDFCellModel] {
        return getAllRealmObjects().compactMap { realmModel in
            guard let pdfDocument = PDFDocument(data: realmModel.dataPDF),
                  let pdfPage = pdfDocument.page(at: 0) else { return nil }
            
            let pdfPageImage = pdfPage.thumbnail(of: CGSize(width: 70, height: 100), for: .mediaBox)
            
            return PDFCellModel(id: realmModel.id, image: pdfPageImage, name: realmModel.fileName, size: realmModel.fileSize, dateCreated: realmModel.dateCreated, dataPDF: realmModel.dataPDF)
        }
    }
    
    func getItemWithID(id: String) -> PDFCellModel? {
        return getRealmItemWithID(id: id).flatMap { realmModel in
            
            guard let pdfDocument = PDFDocument(data: realmModel.dataPDF),
                  let pdfPage = pdfDocument.page(at: 0) else {
                return nil
            }
            
            let pdfPageImage = pdfPage.thumbnail(of: CGSize(width: 70, height: 100), for: .mediaBox)
            
            let pdfCellModel = PDFCellModel(id: realmModel.id, image: pdfPageImage, name: realmModel.fileName, size: realmModel.fileSize, dateCreated: realmModel.dateCreated, dataPDF: realmModel.dataPDF)
            return pdfCellModel
        }
    }
        
    
    func addNewItemModel(item: PDFCellModel) {
        let model = RealmItemsModel(id: item.id, dataPDF: item.dataPDF, fileSize: item.size, fileName: item.name, dateCreated: item.dateCreated)
        self.realmService.create(model)
    }
        
    func deleteItemModel(item: PDFCellModel) {
        guard let dbItem = getRealmItemWithID(id: item.id) else {
            print("Unable to find Model")
            return
        }
        realmService.delete(dbItem)
    }
}
