//
//  User.swift
//  Library21
//
//  Created by Extollite on 17/05/2021.
//

import Foundation

struct User : Codable {
    let pesel : String
    let firstName : String
    let lastName : String
    
    init() {
        pesel = ""
        firstName = ""
        lastName = ""
    }
}
