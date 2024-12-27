//
//  String+Extensions.swift
//  SmartShop
//
//  Created by abdifatah ahmed on 12/16/24.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isZipCode: Bool {
        let zipCodeRegex = "[0-9]{5}(-[0-9]{4} )?$"
        return NSPredicate(format: "SELF MATCHES %@", zipCodeRegex).evaluate(with: self)
    }
}
