//
//  EnvironmentValues+Extensions.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/25/24.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry var paymentController = PaymentController(httpClient: HTTPClient())
    @Entry var authenticationController = AuthenticationController(httpClient: HTTPClient())
    @Entry var uploaderDownloader = UploaderDownloader(httpClient: HTTPClient())
}


//private struct AuthenticationEnvironmentKey: EnvironmentKey {
//    static let defaultValue = AuthenticationController(httpClient: HTTPClient())
//    
//}
//
//extension EnvironmentValues {
//    var authenticationController: AuthenticationController {
//        get { self[AuthenticationEnvironmentKey.self] }
//        set { self[AuthenticationEnvironmentKey.self] = newValue }
//   

//private struct UploaderEnvironmentKey: EnvironmentKey {
//    static let defaultValue = UploaderDownloader(httpClient: HTTPClient())
//}
//
//extension EnvironmentValues {
//    var uploaderDownloader: UploaderDownloader {
//        get { self[UploaderEnvironmentKey.self] }
//        set { self[UploaderEnvironmentKey.self] = newValue }
//    }
//}
