//
//  API.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/13/24.
//

import Foundation

extension API {
    static func getItems() -> Endpoint<ItemsData> {
        return Endpoint(method: .get,
                        path: .path("/requestAssignmentCalculatorData"))
    }
}
