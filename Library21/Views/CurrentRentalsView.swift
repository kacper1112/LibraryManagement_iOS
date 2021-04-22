//
//  ContentView.swift
//  Library21
//
//  Created by Kacper Stysiński on 29/03/2021.
//

import SwiftUI


struct CurrentRentalsView: View {
    let rentals = [
        Rental(),
        Rental(),
        Rental()
    ]
    
    var body: some View {
        List(rentals) { rental in
            RentalView(rental: rental)
        }
        
//        Button("Guziczek") {
//            print("Siema")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentRentalsView()
    }
}
