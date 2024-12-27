//
//  RequiresAuthentication.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/17/24.
//

import Foundation
import SwiftUI

struct RequiresAuthentication: ViewModifier {
    
    @State private var isLoading: Bool = true
    @AppStorage("userId") private var userId: Int?
    
    func body(content: Content) -> some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else {
                if userId != nil {
                    content
                } else {
                    LoginScreen()
                }
            }
        }.onAppear {
            checkAuthentication()
        }
    }
    
    private func checkAuthentication() {
        guard let token = Keychain<String>.get("jwttoken"), JWTTokenValidator.validate(token: token) else {
            userId = nil
            isLoading = false
            return
        }
        
        isLoading = false
    }
    
}

extension View {
    
    func requiresAuthentication() -> some View {
        modifier(RequiresAuthentication())
    }
}
