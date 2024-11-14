//
//  DateExtension.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import Foundation

extension Date {
    var formattedString: String {
        let fullDateFormatter = DateFormatter()
        fullDateFormatter.locale = Locale(identifier: "ko_KR")
        fullDateFormatter.dateFormat = "yyyy. MM. dd. a hh:mm"
        return fullDateFormatter.string(from: self)
    }
}
