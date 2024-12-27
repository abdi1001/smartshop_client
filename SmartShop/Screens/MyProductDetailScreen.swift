//
//  MyProductDetailScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/18/24.
//

import SwiftUI

struct MyProductDetailScreen: View {
    
    @Environment(ProductStore.self) private var productStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var isPresented: Bool = false
    
    let product: Product
    
    private func deleteProduct() async {
        do {
            try await productStore.deleteProduct(product)
        } catch {
            print("Error deleting product: \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            AsyncImage(url: product.photoUrl) { img in
                img.resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
                    .scaledToFit()
            } placeholder: {
                ProgressView("Loading...")
            }
            
            Text(product.name)
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(product.description)
                .padding([.top], 5)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(product.price, format: .currency(code: "USD"))
                .padding([.top], 2)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(role: .destructive) {
                Task {
                    await deleteProduct()
                    dismiss()
                }
            } label: {
                Text("Delete")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .cornerRadius(25)
            }.buttonStyle(.borderedProminent)

        }.padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Update") {
                        isPresented = true
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    AddProductScreen(product: product)
                }
                
            }
    }
}

#Preview {
    NavigationStack {
        MyProductDetailScreen(product: .preview)
    }
    .environment(ProductStore(httpClient: .development))
}
