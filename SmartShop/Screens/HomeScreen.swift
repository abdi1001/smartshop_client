//
//  HomeScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/17/24.
//

import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {
    case home
    case myProducts
    case cart
    case profile
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Label("Home", systemImage: "house")
        case .myProducts:
            Label("My Products", systemImage: "star")
        case .cart:
            Label("Cart", systemImage: "cart")
        case .profile:
            Label("Profile", systemImage: "person")
        }
    }
    
    @MainActor
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            NavigationStack {
                ProductListScreen()
            }
            
        case .myProducts:
            NavigationStack {
                MyProductListScreen()
            }
                .requiresAuthentication()
        case .cart:
            NavigationStack {
                CartScreen()
            }
                .requiresAuthentication()
        case .profile:
            NavigationStack {
                ProfileScreen()
                    .requiresAuthentication()
            }
            
        }
    }
}

struct HomeScreen: View {
    
    @Environment(CartStore.self) private var cartStore
    @State var selection: AppScreen?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.destination
                    .tag(screen as AppScreen)
                    .tabItem { screen.label }
                    .badge((screen as AppScreen?) == .cart ? cartStore.cart?.itemCount ?? 0: 0)
            }
        }
    }
}

#Preview {
   // NavigationStack {
        HomeScreen()
            .environment(ProductStore(httpClient: .development))
            .environment(CartStore(httpClient: .development))
   // }
    
}
