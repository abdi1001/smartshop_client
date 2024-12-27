//
//  OrderStore.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/25/24.
//

import Foundation
import Observation

@Observable
@MainActor
class OrderStore {
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func saveOrder(order: Order) async throws {
        
        let body = try JSONSerialization.data(withJSONObject: order.toRequestBody(), options: [])
        
        let resource = Resource(url: Constants.Urls.createOrder, method: .post(body), modelType: saveOrderRespose.self)
        
        let response = try await httpClient.load(resource)
        
        if !response.success {
            throw OrderError.operationFailed(response.message ?? "")
        }
    }
}
