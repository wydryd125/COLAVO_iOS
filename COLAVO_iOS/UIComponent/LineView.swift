//
//  LineView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI

struct LineView: View {
    var isDotted: Bool
    var lineWidth: CGFloat = 0.6
    var color: Color = .lightGray

    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .frame(height: lineWidth)
            .overlay(
                Rectangle()
                    .stroke(style: StrokeStyle(
                        lineWidth: lineWidth,
                        dash: isDotted ? [2, 2] : []
                    ))
                    .foregroundColor(color)
            )
    }
}
