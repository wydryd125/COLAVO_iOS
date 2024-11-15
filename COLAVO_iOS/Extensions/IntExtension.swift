//
//  IntExtension.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/14/24.
//

import Foundation

extension Int {
    func formattedCurrency(code: CurrencyCode) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedAmount = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        
        switch code {
        case .kr:
            return "\(formattedAmount)원"
        case .us:
            return "$\(formattedAmount)"
        }
    }
}
