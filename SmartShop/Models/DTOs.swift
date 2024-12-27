//
//  DTOs.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/16/24.
//

import Foundation

struct RegisterResponse: Codable {
    let message: String?
    let success: Bool
}

struct LoginResponse: Codable {
    let message: String?
    let success: Bool
    let userId: Int?
    let token: String?
    let username: String?
}

struct UploadDataResponse: Codable {
    let message: String?
    let success: Bool
    let downloadUrl: URL?
}

//return res.json({message: 'file uploaded successfully', downloadUrl: downloadUrl, success: true})

struct Product: Codable, Identifiable, Hashable {
    var id: Int?
    let name: String
    let price: Double
    let description: String
    let photoUrl: URL?
    let userId: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, name, price, description
        case photoUrl = "photo_url"
        case userId = "user_id"
    }
}

extension Product {
    
    static var preview: Product {
        Product(id: 12, name: "Mirra Chair", price: 500, description: "The mirra chari by Herman Miller is a modern and elegant chair that is perfect for any room.", photoUrl: URL(string: "http://localhost:8080/api/uploads/chair.png")!, userId: 6)
    }
    
    func encode() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

struct ErrorResponse: Codable {
    let message: String?
    let success: Bool
}

struct CreatProductResponse: Codable {
    let success: Bool
    let message: String?
    let product: Product?
}

struct DeleteProductResponse: Codable {
    let success: Bool
    let message: String?
}

struct UpdateProductResponse: Codable {
    let success: Bool
    let message: String?
    let product: Product?
}

struct Cart: Codable, Hashable {
    var id: Int?
    let userId: Int
    var cartItems: [CartItem] = []
    
    private enum CodingKeys: String, CodingKey {
        case id, cartItems
        case userId = "user_id"
    }
    
    var total: Double {
        cartItems.reduce(0.0, { total, cartItem in
            total + (cartItem.product.price * Double(cartItem.quantity))
        })
    }
    
    var itemCount: Int {
        cartItems.reduce(0, { total, cartItem in
            total + cartItem.quantity
        })
    }
}

struct CartItem: Codable, Identifiable, Hashable {
    let id: Int?
    let product: Product
    var quantity: Int = 1
}

extension Cart {
    static var preview: Cart {
        return Cart(
            id: 12,
            userId: 6,
            cartItems: [
                CartItem(id: 1, product: Product(
                    id: 12,
                    name: "Product 1",
                    price: 10,
                    description: "Description 1",
                    
                    photoUrl: URL(string: "https://picsum.photos/200/300"),
                    userId: 6
                ),
                         quantity: 2),
                CartItem(id: 2, product: Product(
                    id: 13,
                    name: "Product 2",
                    price: 15,
                    description: "Description 2",
                    
                    photoUrl: URL(string: "https://picsum.photos/200/300"),
                    userId: 6
                ),
                         quantity: 3),
                CartItem(id: 3, product: Product(
                    id: 14,
                    name: "Product 2",
                    price: 20,
                    description: "Description 2",
                    
                    photoUrl: URL(string: "https://picsum.photos/200/300"),
                    userId: 6
                ),
                         quantity: 1)
            ])
    }
}

struct CartItemResponse: Codable {
    let success: Bool
    let message: String?
    let cartItem: CartItem?
}

struct CartResponse: Codable {
    let success: Bool
    let message: String?
    let cart: Cart?
}

struct DeleteCartItemResponse: Codable {
    let success: Bool
    let message: String?
}

struct UserInfo: Codable, Equatable {
    var firstName: String?
    var lastName: String?
    var street: String?
    var city: String?
    var state: String?
    var zipCode: String?
    var country: String?
    
    private enum CodingKeys: String, CodingKey {
        case street, city, state, country
        case firstName = "first_name"
        case lastName = "last_name"
        case zipCode = "zip_code"
    }
    
    var fullName: String {
        [firstName, lastName].compactMap { $0 }.joined(separator: " ")
    }
    
    var address: String {
        [
            street,
            [city, state].compactMap{ $0 }.joined(separator: " ")
         , zipCode
        ].compactMap{ $0 }.joined(separator: " ")
    }
}

struct UserInfoResponse: Codable {
    let success: Bool
    let message: String?
    let userInfo: UserInfo?
}

// Order Item

struct OrderItem: Codable, Identifiable {
    var id: Int?
    let product: Product
    var quantity: Int = 1
    
    init(from cartItem: CartItem) {
        self.id = cartItem.id
        self.product = cartItem.product
        self.quantity = cartItem.quantity
    }
}

struct Order: Codable, Identifiable {
    var id: Int?
    let userId: Int
    let total: Double
    let items: [OrderItem]
    
    init(from cart: Cart) {
        self.id = nil
        self.userId = cart.userId
        self.total = cart.total
        self.items = cart.cartItems.map(OrderItem.init)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, total, items
        case userId = "user_id"
    }
    
    func toRequestBody() -> [String: Any] {
            return [
                "total": total,
                "order_items": items.map({ item in
                    [
                        "product_id": item.product.id,
                        "quantity": item.quantity
                    ]
                })
            ]
    }

}

struct CreatePaymentIntentResponse: Codable {
    let paymentIntentClientSecret: String?
    let CustomerEphemeralKeySecret: String?
    let customerId: String?
    let publishableKey: String?
    
    enum CodingKeys: String, CodingKey {
        case publishableKey
        case paymentIntentClientSecret = "paymentIntent"
        case CustomerEphemeralKeySecret = "ephemeralKey"
        case customerId = "customer"
    }
}

struct saveOrderRespose: Codable {
    let success: Bool
    let message: String?
}
