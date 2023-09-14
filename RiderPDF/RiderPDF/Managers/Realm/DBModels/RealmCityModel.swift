//
//  RealmCityModel.swift
//  Sweety Weather
//
//  Created by Igor Kononov on 01.09.2023.
//

import Foundation
import RealmSwift

class RealmItemsModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var dataPDF: Data
    @Persisted var fileSize: String
    @Persisted var fileName: String
    @Persisted var dateCreated: Date
    
    convenience init(id: String, dataPDF: Data, fileSize: String, fileName: String, dateCreated: Date) {
        self.init()
        self.id = id
        self.dataPDF = dataPDF
        self.fileSize = fileSize
        self.fileName = fileName
        self.dateCreated = dateCreated
    }
}
