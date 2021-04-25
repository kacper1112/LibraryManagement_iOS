//
//  Author.swift
//  Library21
//
//  Created by Kacper Stysiński on 25/04/2021.
//

import Foundation

struct Author : Identifiable, Hashable, Codable {
    var id:Int64
    var firstName:String
    var lastName:String
    
    init(id:Int64, firstName:String, lastName:String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}
