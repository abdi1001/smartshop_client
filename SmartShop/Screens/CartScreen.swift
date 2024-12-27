//
//  CartScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/20/24.
//

import SwiftUI

struct CartScreen: View {
    
    @Environment(CartStore.self) private var cartStore
    @AppStorage("userId") private var userId: Int?
    
    @State private var proceedToCheckout: Bool = false
    
    var body: some View {
        List {
            if let cart = cartStore.cart {
                
                HStack {
                    Text("Total: ")
                        .font(.title)
                    Text(cart.total, format: .currency(code: "USD"))
                        .font(.title)
                        .bold()
                }
                
                Button {
                    proceedToCheckout = true
                } label: {
                    Text("Proceed to Checkout ^[(\(cart.itemCount) Item](inflected: true))")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                }.buttonStyle(.borderless)

                
                ForEach(cart.cartItems) { cartItem in
                    CartItemView(cartItem: cartItem)
                }
            } else {
                ContentUnavailableView("No items in the cart", systemImage: "cart")
            }
        }
        .navigationDestination(isPresented: $proceedToCheckout, destination: {
            if let cart = cartStore.cart {
                CheckoutScreen(cart: cart)
            }
        })
//        .task {
//            await cartStore.loadCart()
//        }
    }
}

#Preview {
    NavigationStack {
        CartScreen()
    }
    .environment(CartStore(httpClient: .development))
   
}
