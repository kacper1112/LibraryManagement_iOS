//
//  BookRaiting.swift
//  Library21
//
//  Created by Extollite on 18/05/2021.
//

import Foundation

struct BookRaiting : Identifiable, Hashable, Codable {
    var id: Int64
    var bookId : Int64
    var raiting : Int32
    
    init() {
        id = 0
        bookId = 0
        raiting = 10
    }
}
