//
//  BookCopy.swift
//  Library21
//
//  Created by Jędrzej Racibor on 26/04/2021.
//

import Foundation
import SwiftUI

struct BookCopy : Identifiable, Codable {
    private static var dateFormatter = prepareFormatter()
    
    let id:Int64
    let alternativeTitle:String?
    let bookId:Int64
    let languageCode:String
    let publisherName:String
    let yearOfRelease:Int32
    let pagesCount:Int32
    let available:Bool
    private let dueDate:String?
    var dueDateAsDate : Date? {
        get {
            if (dueDate == nil) {
                return nil
            }
            return DateFormatter.iso8601.date(from: dueDate!)!
        }
    }
    
    var dueDateFormatted : String {
        get {
            if (dueDate == nil) {
                return ""
            }
            return BookCopy.dateFormatter.string(from: dueDateAsDate!)
        }
    }
    
    private static func prepareFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}
