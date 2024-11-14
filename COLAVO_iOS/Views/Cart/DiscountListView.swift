//
//  DiscountListView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/14/24.
//

import Foundation
import SwiftUI

struct DiscountListView: View {
    let discount: Discount
    @State private var selectedItems = [Item]()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                discountTItleView
                listView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 16)
            .background(Color.white)
        }
    }
    private var discountTItleView: some View {
        HStack {
            Text(discount.name + " (\(discount.getDiscountPercent()))")
                .font(.headline)
                .foregroundColor(.darkGray)
        }
    }
    
    private var listView: some View {
        ScrollView(showsIndicators: true) {
            Spacer()
                .frame(height: 16)
            LazyVStack(spacing: 24) {
                ForEach(discount.items,  id: \.id) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .foregroundColor(Color.darkGray)
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .lineLimit(2)
                                .truncationMode(.tail)
                            Text(item.getAmountString() + " -> \(item.getDiscountAmountString(rate: discount.rate))")
                                .foregroundColor(.colavoPink)
                                .font(.system(size: 12))
                        }
                        Spacer()
                        Image("done")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.colavoPurple)
                            .frame(width: 24, height: 24, alignment: .trailing)
                    }
                }
            }
            .padding(.horizontal, 24)
            .onAppear {
            }
        }
    }
}
