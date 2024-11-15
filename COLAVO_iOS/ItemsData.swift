//
//  ItemsData.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/13/24.
//

import Foundation

enum CurrencyCode: String, Codable {
    case kr = "KRW"
    case us = "USD"
}

struct ItemsData: Codable {
    let items: [String: Item]
    let discounts: [String: Discount]
    let currencyCode: CurrencyCode
    
    enum CodingKeys: String, CodingKey {
        case items
        case discounts
        case currencyCode = "currency_code"
    }
    
    func sortedItems() -> [Item] {
        let sortedKeys = items.keys.sorted {
            let number1 = Int($0.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)) ?? 0
            let number2 = Int($1.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)) ?? 0
            return number1 < number2
        }
        return sortedKeys.compactMap { items[$0] }
    }
    
    func sortedDiscount() -> [Discount] {
        let sortedKeys = discounts.keys.sorted {
            let number1 = Int($0.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)) ?? 0
            let number2 = Int($1.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)) ?? 0
            return number1 < number2
        }
        return sortedKeys.compactMap { discounts[$0] }
    }
}

// 시술
struct Item: Identifiable, Codable, Equatable {
    let id: UUID
    var count: Int
    let name: String
    let price: Int
    
    init(count: Int, name: String, price: Int) {
        self.id = UUID()
        self.count = count
        self.name = name
        self.price = price
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case count
        case name
        case price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.count = try container.decode(Int.self, forKey: .count)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Int.self, forKey: .price)
        self.id = UUID()
    }
    
    func getAmount() -> Int {
        return price * count
    }
    
    func getDiscountAmount(rate: Double) -> Int {
        let amount = getAmount()
        return amount - Int(Double(amount) * rate)
    }
}

// 할인
struct Discount: Identifiable, Codable {
    let id: UUID
    let name: String
    let rate: Double
    var items = [Item]()
    
    init(name: String, rate: Double) {
        self.id = UUID()
        self.name = name
        self.rate = rate
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case rate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.rate = try container.decode(Double.self, forKey: .rate)
        self.id = UUID()
    }
    
    func getDiscountPercent() -> String {
        return "\(Int(self.rate * 100))%"
    }
    
    func getDiscountAmount() -> Int {
        return items.reduce(0) { $0 + $1.getDiscountAmount(rate: rate) }
    }
}
