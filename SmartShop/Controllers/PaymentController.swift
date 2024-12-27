//
//  PaymentController.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/24/24.
//

import Foundation
import Stripe
import StripePaymentSheet

struct PaymentController {
    let httpClient: HTTPClient
    
    @MainActor
    func preparePaymentSheet(for cart: Cart) async throws -> PaymentSheet {
        let body = ["totalAmount": cart.total]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.createPaymentIntent, method: .post(bodyData), modelType: CreatePaymentIntentResponse.self)
        
        let response = try await httpClient.load(resource)
        
        guard let customerId = response.customerId, let CustomerEphemeralKeySecret = response.CustomerEphemeralKeySecret, let paymentIntentClientSecret = response.paymentIntentClientSecret else {
            throw PaymentServiceError.missingPaymentDetails
        }
        STPAPIClient.shared.publishableKey = response.publishableKey
        
        // create payment sheet instance
        var configuration = PaymentSheet.Configuration()
        
        configuration.merchantDisplayName = "SmartShop, Inc."
        configuration.customer = .init(id: customerId, ephemeralKeySecret: CustomerEphemeralKeySecret)
        
        return PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
    }
}
