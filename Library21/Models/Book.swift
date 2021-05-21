//
//  Book.swift
//  Library21
//
//  Created by Kacper Stysiński on 02/04/2021.
//

import Foundation
import SwiftUI

protocol Book {
    var id:Int64 { get }
    var title:String { get }
    var authors:[Author] { get }
    var genreId:Int64 { get }
    var yearOfFirstRelease:Int64 { get }
    var description:String? { get }
}

extension Book {
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


