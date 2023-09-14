//
//  PDFOptionsModel.swift
//  RiderPDF
//
//  Created by Igor Kononov on 13.09.2023.
//

import Foundation
import UIKit

enum PDFOptionsSectorsModel: Hashable {
    case firstSector
    case secondSector
    
    var options: [PDFOptionsModel] {
        switch self {
            
        case .firstSector:
            return [.edit, .sign, .convert]
        case .secondSector:
            return [.share, .saveOnDevice, .saveInCloud, .rename, .delete]
        }
    }
}


enum PDFOptionsModel: Hashable {
    case edit, sign, convert, share, saveOnDevice, saveInCloud, rename, delete
    
    var name: String {
        switch self {
            
        case .edit:
            return "Edit"
        case .sign:
            return "Sign"
        case .convert:
            return "Convert"
        case .share:
            return "Share"
        case .saveOnDevice:
            return "Save on device"
        case .saveInCloud:
            return "Save in cloud"
        case .rename:
            return "Rename"
        case .delete:
            return "Delete"
        }
    }
    
    var image: String {
        switch self {
            
        case .edit:
            return "Edit_icon"
        case .sign:
            return "Sign_icon"
        case .convert:
            return "Convert_icon"
        case .share:
            return "Share_icon"
        case .saveOnDevice:
            return "Save on device_icon"
        case .saveInCloud:
            return "Save in cloud_icon"
        case .rename:
            return "Rename_icon"
        case .delete:
            return "Delete_icon"
        }
    }
}
