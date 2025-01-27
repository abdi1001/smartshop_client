//
//  CartStore.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/19/24.
//

import Foundation
import Observation

@MainActor
@Observable
class CartStore {
    
    let httpClient: HTTPClient
    var cart: Cart?
    
    var lastError: Error?
    
//    var total: Double {
//        cart?.cartItems.reduce(0.0, { total, cartItem in
//            total + (cartItem.product.price * Double(cartItem.quantity))
//        }) ?? 0.0
//    }
//    
//    var itemCount: Int {
//        cart?.cartItems.reduce(0, { total, cartItem in
//            total + cartItem.quantity
//        }) ?? 0
//    }
    
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadCart() async {
        
        do {
            let resource = Resource(url: Constants.Urls.loadCart, modelType: CartResponse.self)
            
            let response = try await httpClient.load(resource)
            
            if let cart = response.cart, response.success {
                self.cart = cart
            }
        } catch {
            lastError = error
        }
       
    }
    
    func deleteCartItem(cartItemId: Int) async throws {
        let resource = Resource(url: Constants.Urls.deleteCartItem(cartItemId), method: .delete, modelType: DeleteCartItemResponse.self)
        
        let response = try await httpClient.load(resource)
        
        if response.success {
            if let cart = cart {
                self.cart?.cartItems = cart.cartItems.filter { $0.id != cartItemId}
                
            } else {
                throw CartError.operationFailed(response.message ?? "")
            }
        }
    }
    
    func emptyCart() {
        cart?.cartItems = []
    }
    
    
    func updateItemQuantity(productId: Int, quantity: Int) async throws {
        
        try await addItemToCart(productId: productId, quantity: quantity)
    }
    
    func addItemToCart(productId: Int, quantity: Int) async throws {
        
        let body = ["productId": productId, "quantity": quantity]
        
        let bodyData = try! JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.addCartItem,method: .post(bodyData), modelType: CartItemResponse.self)
        
        let response = try await httpClient.load(resource)
        
        if let cartItem = response.cartItem, response.success {
            
            if cart == nil {
                guard let userId = UserDefaults.standard.userId else {
                    throw UserError.missingUserId
                }
                
                cart = Cart(userId: userId)
            }
            if let index = cart?.cartItems.firstIndex(where: {$0.id == cartItem.id}) {
                cart?.cartItems[index] = cartItem
            } else {
                cart?.cartItems.append(cartItem)
            }
        } else {
            throw CartError.operationFailed(response.message ?? "")
        }
        
        
    }
}
