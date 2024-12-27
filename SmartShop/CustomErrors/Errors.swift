//
//  Errors.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/17/24.
//

import Foundation

enum ProductError: Error {
    case missingUserId
    case invalidPrice
    case operationFailed(String)
    case uploadFailed(String)
    case missingImage
    case productNotFound
}

enum UserError: Error {
    case missingUserId
    case missingEmail
    case invalidEmail
    case missingPassword
    case invalidPasswordLength
    case invalidPasswordFormat
    case missingFirstName
    case missingLastName
    case missingPhoneNumber
    case invalidPhoneNumberLength
    case operationFailed(String)
}

enum CartError: Error {
    case missingUserId
    case missingProductId
    case invalidQuantity
    case operationFailed(String)
}

enum PaymentServiceError: Error {
    case missingUserId
    case missingPaymentId
    case invalidPaymentId
    case missingPaymentDetails
    case operationFailed(String)
}

enum OrderError: Error {
    case missingUserId
    case missingOrderId
    case invalidOrderId
    case missingOrderDetails
    case operationFailed(String)
}
