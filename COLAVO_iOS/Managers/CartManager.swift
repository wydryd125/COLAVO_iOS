//
//  CartManager.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/13/24.
//

import Foundation

class CartManager: ObservableObject {
    public static let shared = CartManager()
    
    @Published var selectedTreatments: [Item] = []
    @Published var selectedDiscounts: [Discount] = []

    private init() {}
    
    func getDiscountAmount(discount: Discount) -> String {
        let itemsAmount = selectedTreatments.filter { $0.isDiscounted }.reduce(0) { $0 + $1.price }
        let discountAmount = Int(Double(itemsAmount) * discount.rate)
        return "-\(discountAmount.formattedCurrency())(\(discount.getDiscountPercent()))"
    }
    
    func getDiscountItemList() -> String {
        return selectedTreatments
            .filter { $0.isDiscounted }
            .map { $0.name }
            .joined(separator: ", ")
    }
    
    func getTotalAmount() -> String {
        let totalAmount = selectedTreatments.reduce(0) { total, item in
            let discountAmount = selectedDiscounts
                .filter { _ in item.isDiscounted }
                .reduce(0) { totalDiscount, discount in
                    totalDiscount + Int(Double(item.price) * discount.rate)
                }
            return total + item.price - discountAmount
        }
        return totalAmount.formattedCurrency()
    }
}
