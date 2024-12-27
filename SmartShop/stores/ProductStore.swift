//
//  ProductStore.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/17/24.
//

import Foundation
import Observation

@MainActor
@Observable
class ProductStore {
    
    let httpClient: HTTPClient
    private(set) var products: [Product] = []
    private(set) var myProducts: [Product] = []
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func loadAllProducts() async throws {
        let resource = Resource(url: Constants.Urls.products, modelType: [Product].self)
        products = try await httpClient.load(resource)
    }
    
    func loadMyProducts(by userId: Int) async throws {
        let resource = Resource(url: Constants.Urls.myProducts(userId), modelType: [Product].self)
        myProducts = try await httpClient.load(resource)
        
    }
    
    func saveProduct(_ product: Product) async throws {
        let resource = Resource(url: Constants.Urls.products, method: .post(product.encode()), modelType: CreatProductResponse.self)
        let response = try await httpClient.load(resource)
        if let product = response.product, response.success {
            myProducts.append(product)
        } else {
            throw ProductError.operationFailed(response.message ?? " ")
        }
    }
    
    func deleteProduct(_ product: Product) async throws {
        
        guard let productId = product.id else {
            throw ProductError.productNotFound
        }
        
        let resouce = Resource(url: Constants.Urls.deleteProduct(productId), method: .delete, modelType: DeleteProductResponse.self)
        let response = try await httpClient.load(resouce)
        if response.success {
            myProducts.removeAll(where: { $0.id == productId })
        } else {
            throw ProductError.operationFailed(response.message ?? "")
        }
    }
    
    func updateProduct(_ product: Product) async throws {
        
        guard let productId = product.id else {
            throw ProductError.productNotFound
        }
        
        let resouce = Resource(url: Constants.Urls.updateProduct(productId), method: .put(product.encode()), modelType: UpdateProductResponse.self)
        let response = try await httpClient.load(resouce)
        if let updatedProduct = response.product, response.success {
            if let indexToUpdate = myProducts.firstIndex(where: { $0.id == productId }) {
                myProducts[indexToUpdate] = updatedProduct
            }
        } else {
            throw ProductError.operationFailed(response.message ?? "")
        }
    }
}
