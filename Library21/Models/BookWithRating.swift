//
//  BookWithRating.swift
//  Library21
//
//  Created by Kacper Stysiński on 05/19/2021.
//

import Foundation
import SwiftUI

struct BookWithRating : Book, Identifiable, Codable {
    let id:Int64
    let title:String
    let authors:[Author]
    let genreId:Int64
    let yearOfFirstRelease:Int64
    let description:String?
    let rating : Int32
}


