//
//  ColorExtension.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI

extension Color {
    init(red: Int, green: Int, blue: Int, alpha: Double = 1) {
        self.init(red: Double(red) / 255.0,
                  green: Double(green) / 255.0,
                  blue: Double(blue) / 255.0,
                  opacity: alpha)
    }
    
    init(hex: Int, alpha: CGFloat = 1) {
        let red = (hex >> 16) & 0xFF
        let green = (hex >> 8) & 0xFF
        let blue = hex & 0xFF
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let lightPurple = Color(red: 171, green: 159, blue: 235)
    static let colavoPurple = Color(red: 150, green: 135, blue: 231)
    static let lightPink = Color(red: 251, green: 238, blue: 243)
    static let midPink = Color(red: 234, green: 172, blue: 193)
    static let colavoPink = Color(red: 222, green: 141, blue: 175)
    static let bgGray = Color(red: 242, green: 242, blue: 242)
    static let lightGray = Color(red: 235, green: 240, blue: 240)
    static let midGray = Color(red: 195, green: 203, blue: 210)
    static let pupleGray = Color(red: 100, green: 98, blue: 123)
    static let blueGray = Color(red: 182, green: 190, blue: 200)
    static let darkGray = Color(red: 98, green: 98, blue: 98)
}
