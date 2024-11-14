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
    
    // 아이템 추가
    func addItem(item: Item) {
        if let index = selectedTreatments.firstIndex(where: { $0.id == item.id }) {
            if selectedTreatments[index].count < 10 {
                selectedTreatments[index].count += 1
            }
            for (discountIndex, discount) in selectedDiscounts.enumerated() {
                if let itemIndex = discount.items.firstIndex(where: { $0.id == item.id }) {
                    selectedDiscounts[discountIndex].items[itemIndex].count = selectedTreatments[index].count
                }
            }
        }
    }
    
    // 아이템 제거
    func removeItem(item: Item) {
        if let index = selectedTreatments.firstIndex(where: { $0.id == item.id }) {
            if selectedTreatments[index].count > 1 {
                selectedTreatments[index].count -= 1
            } else {
                selectedTreatments.remove(at: index)
            }
        }
        for (discountIndex, discount) in selectedDiscounts.enumerated() {
            if let itemIndex = discount.items.firstIndex(where: { $0.id == item.id }) {
                if discount.items[itemIndex].count > 1 {
                    selectedDiscounts[discountIndex].items[itemIndex].count -= 1
                } else {
                    selectedDiscounts[discountIndex].items.remove(at: itemIndex)
                }
            }
        }
    }
    
    // 할인 금액 계산
    func getDiscountAmount(discount: Discount) -> String {
        let items = discount.items.isEmpty && !selectedTreatments.isEmpty ? selectedTreatments : discount.items
        let itemsAmount = items.reduce(0) { $0 + ($1.price * $1.count) }
        let discountAmount = Int(Double(itemsAmount) * discount.rate)
        return "-\(discountAmount.formattedCurrency())(\(discount.getDiscountPercent()))"
    }
    
    // 할인 항목 리스트
    func getDiscountItemList(discount: Discount) -> String {
        let items = discount.items.isEmpty && !selectedTreatments.isEmpty ? selectedTreatments : discount.items
        let itemList = items.map { $0.count > 1 ? "\($0.name)x\($0.count)" : $0.name }.joined(separator: ", ")
        return items.isEmpty ? "시술 선택해주세요." : itemList
    }
    
    // 최종 금액 계산
    func getFinalAmount() -> String {
        let itemAmount = selectedTreatments.reduce(0) { total, item in
            total + item.price * item.count
        }
        
        var discountAmount = 0
        for discount in selectedDiscounts {
            for item in discount.items {
                let itemDiscount = Int(Double(item.price) * Double(item.count) * discount.rate)
                discountAmount += itemDiscount
            }
        }
        return (itemAmount - discountAmount).formattedCurrency()
    }
}
