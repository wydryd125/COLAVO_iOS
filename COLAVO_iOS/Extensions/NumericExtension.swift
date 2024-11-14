//
//  NumericExtension.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/14/24.
//

import Foundation

extension Int {
    func formattedCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        
        let formattedAmount = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        
        return "\(formattedAmount)원"
    }
}
