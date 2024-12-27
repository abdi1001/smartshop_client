//
//  JWTTokenValidator.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/17/24.
//

import Foundation
import JWTDecode

struct JWTTokenValidator {
    
    static func validate(token: String?) -> Bool {
        guard let token else { return false }
        do {
            let jwt = try decode(jwt: token)
            
            if let expirationDate = jwt.expiresAt {
                let currentDate = Date()
                if currentDate >= expirationDate {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
