//
//  ItemsRepository.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/13/24.
//

import Foundation
import Combine

final class ItemsRepository {
    private let client = NetworkManager()

    func getItems() -> AnyPublisher<ItemsData, NetworkError> {
        client.request(API.getItems())
    }
}
