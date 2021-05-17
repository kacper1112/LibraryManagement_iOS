//
//  PasswordEditView.swift
//  Library21
//
//  Created by Extollite on 17/05/2021.
//

import Foundation
import SwiftUI

struct PasswordEditView: View {
    @Environment(\.presentationMode) var presentation

    @EnvironmentObject private var session: LibraryService
    @State private var newPassword = ""
    @State private var confirmedPassword = ""
    @State private var incorrectPassword = false
    @State private var success = false
    
    var body: some View {
        Form {
            Section(header: Text("Password")) {
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm New Password", text: $confirmedPassword)
                Button(action: {
                    changePassword()
                }, label: {
                    Text("Update password")
                })
            }
            .alert(isPresented: self.$success) {
                Alert(title: Text("Success"),
                      message: Text("Password changed successfully!"),
                      dismissButton: .cancel(Text("Ok")) {presentation.wrappedValue.dismiss()}
                )
            }
        }
        .alert(isPresented: self.$incorrectPassword) {
            Alert(title: Text("Action failed"), message: Text("Incorrect new password!"), dismissButton: .destructive(Text("Ok")))
        }
    }
    
    private func changePassword() {
        if isPasswordValid() {
            session.changePassword(session.user!.pesel, newPassword) {
                newPassword = ""
                confirmedPassword = ""
                success.toggle()
            }
        } else {
            incorrectPassword.toggle()
        }
    }
    
    private func isPasswordValid() -> Bool {
        if !newPassword.isEmpty && newPassword == confirmedPassword {
            return true
        }
        
        return false
    }
}
