//
//  AccountView.swift
//  Library21
//
//  Created by Kacper Stysiński on 01/04/2021.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var session: LibraryService
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PasswordEditView()) {
                    VStack(spacing: 0) {
                        HStack {
                            Text("Change password")
                                .font(.body)
                                .foregroundColor(Color.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(.systemGray3))
                                .font(.system(size: 20))
                        }
                        .contentShape(Rectangle())
                        .padding()
        
                        Divider()
                    }
                }
                Spacer()
            }
            .navigationBarTitle("\(session.user!.firstName) \(session.user!.lastName)")
            .navigationBarItems(
                leading:
                    Text("\(session.user!.pesel)")
                    .font(.body)
                    .foregroundColor(Color(.systemGray)),
                trailing:
                    Button {
                        session.logout()
                    } label : {
                        Text("Logout")
                    }
            )
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
