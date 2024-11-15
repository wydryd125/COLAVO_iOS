//
//  SelectedDiscountView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/14/24.
//

import Foundation
import SwiftUI

struct SelectedDiscountView: View {
    var discount: Discount
    @State private var showAlert = false
    @EnvironmentObject private var viewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                discountTitleView
                listView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 16)
            .background(Color.white)
        }
    }
    
    private var discountTitleView: some View {
        ZStack {
               Button(action: {
                   dismiss()
               }) {
                   Image("dismiss")
                       .renderingMode(.template)
                       .foregroundColor(.midGray)
                       .frame(maxWidth: .infinity, alignment: .leading)
               }
               Text(discount.name + " (\(discount.getDiscountPercent()))")
                   .font(.headline)
                   .foregroundColor(.darkGray)
                   .frame(maxWidth: .infinity)
           }
           .padding(.horizontal, 24)
    }
    
    private var listView: some View {
        ScrollView(showsIndicators: true) {
            Spacer().frame(height: 16)
            LazyVStack(spacing: 24) {
                ForEach(discount.items, id: \.id) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(item.name) x \(item.count)")
                                .foregroundColor(Color.darkGray)
                                .font(.system(size: 14))
                                .fontWeight(.medium)
                                .lineLimit(2)
                                .truncationMode(.tail)
                            let code = viewModel.itemsData?.currencyCode ?? .kr
                            Text(item.getAmount().formattedCurrency(code: code) + " -> \(item.getDiscountAmount(rate: discount.rate).formattedCurrency(code: code))")
                                .foregroundColor(.colavoPink)
                                .font(.system(size: 12))
                        }
                        Spacer()
                        Button(action: {
                            showAlert = true
                        }) {
                            Image("done")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.colavoPurple)
                                .frame(width: 24, height: 24, alignment: .trailing)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("할인 적용을 취소하시겠습니까?"),
                                primaryButton: .cancel(Text("취소")),
                                secondaryButton: .destructive(Text("확인"), action: {
                                    viewModel.removeItemFromDiscount(discount: discount, item: item)
                                })
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
