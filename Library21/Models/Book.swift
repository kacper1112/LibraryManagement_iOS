//
//  Rental.swift
//  Library21
//
//  Created by Kacper Stysiński on 02/04/2021.
//

import Foundation
import SwiftUI

struct Book : Identifiable, Codable {
    let id:Int64
    let title:String
    let authors:[Author]
    let genreId:Int64
    let yearOfFirstRelease:Int64
    let description:String?
    let numberOfAvailableCopies:Int32
    
    var authorsString:String {
        if (authors.count == 0) {
            return "Unknown author"
        }
        var authorsString = ""
        var counter = 1
        
        for author in authors {
            authorsString.append("\(author.firstName) \(author.lastName)")
            if (counter < authors.count) {
                authorsString.append(", ")
            }
            counter += 1
        }
        
        return authorsString
    }
}


