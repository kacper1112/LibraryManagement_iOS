//
//  Rental.swift
//  Library21
//
//  Created by Kacper Stysiński on 02/04/2021.
//

import Foundation
import SwiftUI

struct Rental : Identifiable {
    let id:Int
    
    init() {
        id = Int.random(in: 1..<100)
    }
}

struct RentalView: View {
    var rental: Rental

    var body: some View {
        
        HStack {
            Spacer()
            VStack {
                Text("This is top text").padding([.top, .leading, .trailing])
                Text("My id is \(rental.id)")
                Text("This is bottom text").padding([.leading, .bottom, .trailing])
            }
            Spacer()
        }
    }
}
