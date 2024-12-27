//
//  CheckoutScreen.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/24/24.
//

import SwiftUI
import StripePaymentSheet

struct CheckoutScreen: View {
    
    let cart: Cart
    
    @Environment(UserStore.self) private var userStore
    @Environment(OrderStore.self) private var orderStore
    @Environment(CartStore.self) private var cartStore
    @Environment(\.paymentController) private var paymentController
    @State private var paymentSheet: PaymentSheet?
    
    @State private var presentOrderConfirmationScreen: Bool = false
    
    private func paymentCompletion(result: PaymentSheetResult) {
        switch result {
        case .completed:
            Task{
                do {
                    // convert cart to order
                    let order = Order(from: cart)
                  
                    // save the order
                    try await orderStore.saveOrder(order: order)
                    
                    //empty the cart
                    cartStore.emptyCart()
                    
                    // present order confirmation screen
                    presentOrderConfirmationScreen = true
                } catch {
                    print("Error saving order: \(error)")
                }
                
            }
            
            
            
        case .canceled:
            print("Payment cancelled")
        case .failed(let error):
            print("Payment error: \(error)")
        }
    }
    
    var body: some View {
        List {
            VStack(spacing: 10) {
                Text("Place your order")
                    .font(.title3)
                
                HStack {
                    Text("Items:")
                    Spacer()
                    Text(cart.total, format: .currency(code: "USD"))
                }
                
                if let userInfo = userStore.userInfo {
                    Text("Delivering to \(userInfo.fullName)")
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(userInfo.address)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("Please update your profile and add the address information")
                        .foregroundStyle(.red)
                }
            }.padding()
            
            ForEach(cart.cartItems) { cartItem in
                CartItemView(cartItem: cartItem)
            }
            
            if let paymentSheet {
                PaymentSheet.PaymentButton(paymentSheet: paymentSheet, onCompletion: paymentCompletion) {
                    Text("Place your order")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                        .padding()
                        .buttonStyle(.borderless)
                }
            }
        }
        
        .navigationDestination(isPresented: $presentOrderConfirmationScreen, destination: {
                OrderConfirmationScreen()
                .navigationBarBackButtonHidden(true)
        })
        .task(id: cart) {
            do  {
                paymentSheet = try await paymentController.preparePaymentSheet(for: cart)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    NavigationStack
    {
        CheckoutScreen(cart: .preview)
    }
    .environment(UserStore(httpClient: .development))
    .environment(CartStore(httpClient: .development))
    .environment(OrderStore(httpClient: .development))
    .environment(\.paymentController, PaymentController(httpClient: .development))
   
}
