//
//  BookInstance.swift
//  Library21
//
//  Created by Jędrzej Racibor on 26/04/2021.
//

import Foundation
import SwiftUI

struct BookInstance : Identifiable, Codable {
    private static var dateFormatter = prepareFormatter()
    
    let id:Int64
    let alternativeTitle:String?
    let bookId:Int64
    let languageCode:String
    let publisherName:String
    let yearOfRelease:Int32
    let pagesCount:Int32
    let available:Bool
    let dueDate:Date?
    
    var dueDateFormatted : String {
        get {
            BookInstance.dateFormatter.string(from: dueDate!)
        }
    }
    
    private static func prepareFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
