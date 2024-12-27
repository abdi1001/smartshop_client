//
//  SmartShopApp.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/16/24.
//

import SwiftUI
@preconcurrency import Stripe

@main
struct SmartShopApp: App {
    
    @State private var productStore = ProductStore(httpClient: HTTPClient())
    @State private var cartStore = CartStore(httpClient: HTTPClient())
    @State private var userStore = UserStore(httpClient: HTTPClient())
    @State private var orderStore = OrderStore(httpClient: HTTPClient())
    @State private var paymentController = PaymentController(httpClient: HTTPClient())
    
    @AppStorage("userId") private var userId: String?
    
    init () {
        StripeAPI.defaultPublishableKey = ProcessInfo.processInfo.environment["STRIPE_PUBLISHABLE_KEY"] ?? "" // from .env file
    }
    
    private func loadUserInfoAndCart() async {
        
        await cartStore.loadCart()
        
        do {
            try await userStore.loadUserInfo()
        } catch {
            print("Error loading user info and cart: \(error)")
        }
    }
    
    var body: some Scene {
        
        WindowGroup {
            HomeScreen()
                .environment(\.authenticationController, .development)
                .environment(productStore)
                .environment(cartStore)
                .environment(userStore)
                .environment(orderStore)
                .environment(\.paymentController, paymentController)
                .environment(\.uploaderDownloader, UploaderDownloader(httpClient: HTTPClient()))
                .task (id: userId) {
                    
                    if userId != nil {
                        await loadUserInfoAndCart()
                    }
                }
        }
    }
}
