//
//  CartViewModel.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/13/24.
//

import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var itemsData: ItemsData?
    private let repository = ItemsRepository()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
    }
    
    func bind() {
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
}
