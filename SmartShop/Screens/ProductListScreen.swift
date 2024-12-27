//
//  ProductListScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/17/24.
//

import SwiftUI


struct ProductListScreen: View {
    
    @Environment(ProductStore.self) private var productStore
    
    var body: some View {
        List(productStore.products) { product in
            NavigationLink {
                ProductDetailScreen(product: product)
            } label: {
                ProductCellView(product: product)
                    .listRowSeparator(.hidden)
            }

        }
        .navigationTitle("New Arrivals")
        .listStyle(.plain)
        .task {
            do {
                try await productStore.loadAllProducts()
            } catch {
                
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        ProductListScreen()
    }.environment(ProductStore(httpClient: .development))
        .environment(CartStore(httpClient: .development))
    
}
