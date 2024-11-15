//
//  CartViewModel.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/13/24.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var isLoading = true
    @Published var itemsData: ItemsData?
    private let repository = ItemsRepository()
    
    @Published var selectedItems = [Item]()
    @Published var selectedDiscounts = [Discount]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind() {
        isLoading = true
        fetchCartItems()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("!!! Error: \(error)")
                case .finished:
                    print("!!! Fetch completed")
                }
            }, receiveValue: { [weak self] itemsData in
                guard let self = self else { return }
                self.itemsData = itemsData
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    private func fetchCartItems() -> AnyPublisher<ItemsData, Error> {
        Future { [weak self] promise in
            guard let self = self else { return }
            
            self.repository.getItems()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        break
                    }
                }, receiveValue: { items in
                    promise(.success(items))
                })
                .store(in: &self.cancellables)
        }
        .eraseToAnyPublisher()
    }
    
    // 아이템 추가/제거
    func toggleItemSelection(item: Item) {
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            selectedItems.remove(at: index)
            for (discountIndex, _) in selectedDiscounts.enumerated() {
                selectedDiscounts[discountIndex].items.removeAll { $0.id == item.id }
            }
        } else {
            selectedItems.insert(item, at: 0)
            for (discountIndex, _) in selectedDiscounts.enumerated() {
                selectedDiscounts[discountIndex].items.append(item)
            }
        }
    }
    
    // 할인 추가/제거
    func toggleDiscountSelection(discount: Discount) {
        if let index = selectedDiscounts.firstIndex(where: { $0.id == discount.id }) {
            selectedDiscounts.remove(at: index)
        } else {
            selectedDiscounts.insert(discount, at: 0)
        }
    }
    
    // 아이템 한개씩 추가
    func addItem(item: Item) {
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            if selectedItems[index].count < 20 {
                selectedItems[index].count += 1
            }
        }
        
        for (discountIndex, discount) in selectedDiscounts.enumerated() {
            if let itemIndex = discount.items.firstIndex(where: { $0.id == item.id }) {
                selectedDiscounts[discountIndex].items[itemIndex].count = selectedItems.first(where: { $0.id == item.id })?.count ?? 1
            }
        }
    }
    
    // 아이템 한개씩 삭제
    func removeItem(item: Item) {
        // 아이템을 selectedItems에서 제거
        if let index = selectedItems.firstIndex(where: { $0.id == item.id }) {
            if selectedItems[index].count > 1 {
                selectedItems[index].count -= 1
            } else {
                selectedItems.remove(at: index)
            }
        }
        
        for discountIndex in (0..<selectedDiscounts.count).reversed() {
            var discount = selectedDiscounts[discountIndex]
            
            if let itemIndex = discount.items.firstIndex(where: { $0.id == item.id }) {
                if discount.items[itemIndex].count > 1 {
                    selectedDiscounts[discountIndex].items[itemIndex].count -= 1
                } else {
                    selectedDiscounts[discountIndex].items.remove(at: itemIndex)
                }
                
                if selectedDiscounts[discountIndex].items.isEmpty {
                    selectedDiscounts.remove(at: discountIndex)
                }
            }
        }
    }
    
    
    // 할인 별 적용 아이템 삭제
    func removeItemFromDiscount(discount: Discount, item: Item) {
        if let discountIndex = selectedDiscounts.firstIndex(where: { $0.id == discount.id }),
           let itemIndex = selectedDiscounts[discountIndex].items.firstIndex(where: { $0.id == item.id }) {
            selectedDiscounts[discountIndex].items.remove(at: itemIndex)
            
            if selectedDiscounts[discountIndex].items.isEmpty {
                selectedDiscounts.remove(at: discountIndex)
            }
        }
    }
    
    // 할인 항목 업데이트
    func updateDiscountsForSelectedItems() {
        selectedItems.forEach { item in
            for idx in selectedDiscounts.indices {
                var discount = selectedDiscounts[idx]
                if !discount.items.contains(where: { $0.id == item.id }) {
                    discount.items.append(item)
                } else {
                    discount.items = selectedItems
                }
                selectedDiscounts[idx].items = discount.items
            }
        }
    }
    
    // 할인 금액 계산
    func getDiscountAmount(discount: Discount) -> String {
        let items = discount.items.isEmpty && !selectedItems.isEmpty ? selectedItems : discount.items
        let itemsAmount = items.reduce(0) { $0 + ($1.price * $1.count) }
        let discountAmount = Int(Double(itemsAmount) * discount.rate)
        let currencyCode = itemsData?.currencyCode ?? .kr
        return "-\(discountAmount.formattedCurrency(code: currencyCode))(\(discount.getDiscountPercent()))"
    }
    
    // 할인 항목 리스트
    func getDiscountItemList(discount: Discount) -> String {
        let items = discount.items.isEmpty && !selectedItems.isEmpty ? selectedItems : discount.items
        let itemList = items.map { $0.count > 1 ? "\($0.name)x\($0.count)" : $0.name }.joined(separator: ", ")
        return items.isEmpty ? "시술 선택해주세요." : itemList
    }
    
    // 최종 금액
    func getFinalAmount() -> String {
        let itemAmount = selectedItems.reduce(0) { total, item in
            total + item.price * item.count
        }
        var discountAmount = 0
        for discount in selectedDiscounts {
            for item in discount.items {
                let itemDiscount = Int(Double(item.price) * Double(item.count) * discount.rate)
                discountAmount += itemDiscount
            }
        }
        return (itemAmount - discountAmount).formattedCurrency(code: itemsData?.currencyCode ?? .kr)
    }
}
