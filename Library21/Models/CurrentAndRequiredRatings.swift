//
//  UserCurrentAndRequiredRatings.swift
//  Library21
//
//  Created by Kacper Stysiński on 23/05/2021.
//

import Foundation

struct currentAndRequiredRatings : Codable {
    var currentCount: Int64
    var requiredCount: Int64
    
    init() {
        currentCount = 0
        requiredCount = 0
    }
}
