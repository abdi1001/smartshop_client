//
//  CartItemListView.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/20/24.
//

import SwiftUI

struct CartItemListView: View {
    
    let cartItems: [CartItem]
    
    var body: some View {
        ForEach(cartItems) { cartItem in
            CartItemView(cartItem: cartItem)
        }.listStyle(.plain)
    }
}

#Preview {
    CartItemListView(cartItems: Cart.preview.cartItems)
}
