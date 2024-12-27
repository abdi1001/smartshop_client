//
//  RegistrationScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/16/24.
//

import SwiftUI

struct RegistrationScreen: View {
    
    @Environment(\.authenticationController) private var authenticationController
    @Environment(\.dismiss) private var dismiss
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    
    private var isFormValid: Bool {
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func register() async {
        do {
           let response = try await authenticationController.register(username: username, password: password)
            if response.success {
                // dismiss the sheet
                dismiss()
            } else {
                message = response.message ?? ""
            }
        } catch {
            message = error.localizedDescription
        }
        
        username = ""
        password = ""
        
    }
    
    var body: some View {
        Form {
            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
                //.autocorrectionDisabled()
            SecureField("Password", text: $password)
            Button("Register") {
                Task {
                    await register()
                }
            }.disabled(!isFormValid)
            Text(message)
        }.navigationTitle("Register")
    }
}

#Preview {
    NavigationStack {
        RegistrationScreen()
    }.environment(\.authenticationController,.development)
}
