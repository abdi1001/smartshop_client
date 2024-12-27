//
//  MyProductListScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/17/24.
//

import SwiftUI

struct MyProductListScreen: View {
    
    @Environment(ProductStore.self) private var productStore
    @AppStorage("userId") private var userId: Int?
    @State private var isPresented: Bool = false
    @State private var message: String?
    
    private func loadMyProducts() async {
        
        do {
            guard let userId = userId else {
                throw UserError.missingUserId
            }
            
            try await productStore.loadMyProducts(by: userId)
        }catch {
            message = error.localizedDescription
        }
    }
    
    var body: some View {
        List(productStore.myProducts) { product in
            NavigationLink {
                MyProductDetailScreen(product: product)
            } label: {
                myProductCellView(product: product)
            }
            
            
        }
        .listStyle(.plain)
        .task {
            await loadMyProducts()
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add Product") {
                    isPresented = true
                }
            }
        }.sheet(isPresented: $isPresented) {
            NavigationStack {
                AddProductScreen()
            }
            
        }
        .overlay(alignment: .center) {
            
            if let message {
                Text(message).foregroundColor(.red)
            } else if productStore.myProducts.isEmpty {
                ContentUnavailableView("No products available", systemImage: "heart")
            }
            
        }
    }
}

struct myProductCellView: View {
    
    let product: Product
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: product.photoUrl) { img in
                img.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView("Loading...")
            }
            
            Spacer()
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(product.price,format: .currency(code: "USD"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyProductListScreen()
    }.environment(ProductStore(httpClient: .development))
    
}
