//
//  UserDefaults+Extensions.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/19/24.
//

import Foundation

extension UserDefaults {
    private enum keys {
        static let userId = "userId"
    }
    
    var userId: Int? {
        get {
            let id = integer(forKey: keys.userId)
            return id == 0 ? nil : id
        }
        set {
            set(newValue, forKey: keys.userId)
        }
    }
}
