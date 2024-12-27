//
//  ProductDetailScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/19/24.
//

import SwiftUI

struct ProductDetailScreen: View {
    
    @Environment(CartStore.self) private var cartStore
    let product: Product
    
    @State private var quantity: Int = 1
    
    var body: some View {
        ScrollView {
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title)
                .bold()
                .padding([.top], 2)
            
            Stepper(value: $quantity) {
                Text("Quantity: \(quantity)")
            }
            
            Button {
                Task {
                    do {
                        try await cartStore.addItemToCart(productId: product.id!, quantity: quantity)
                    } catch {
                        print("Error adding item to cart: \(error)")
                    }
                }
                
            } label: {
                Text("Add to Cart")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .foregroundStyle(.white)
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
            }

            
        }.padding()
    }
}

#Preview {
    ProductDetailScreen(product: .preview)
        .environment(CartStore(httpClient: .development))
}
