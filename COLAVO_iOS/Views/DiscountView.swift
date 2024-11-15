//
//  DiscountView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI

struct DiscountView: View {
    @EnvironmentObject private var viewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                navigationView
                discountListView
                completeButtonView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
        }
    }
    
    private var navigationView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image("dismiss")
                    .renderingMode(.template)
                    .foregroundColor(.midGray)
            }
            Spacer()
            Text("할인")
                .font(.headline)
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                // Handle any future action for the plus button if needed
            }) {
                Image("plus")
                    .renderingMode(.template)
                    .foregroundColor(.midGray)
            }
        }
        .padding(.horizontal, 16)
    }
    
    private var discountListView: some View {
        ScrollView(showsIndicators: true) {
            Spacer()
                .frame(height: 16)
            LazyVStack(spacing: 24) {
                ForEach(viewModel.itemsData?.sortedDiscount() ?? [], id: \.id) { discount in
                    DiscountRow(discount: discount, isSelected: Binding(
                        get: {
                            viewModel.selectedDiscounts.contains { $0.id == discount.id }
                        },
                        set: { _ in
                            viewModel.toggleDiscountSelection(discount: discount)
                        }
                    ))
                    .frame(height: 40)
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var completeButtonView: some View {
        VStack(spacing: 12) {
            Spacer().frame(height: 8)
            Text("할인을 선택하세요(여러개 선택 가능)")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                for index in viewModel.selectedDiscounts.indices {
                    var discount = viewModel.selectedDiscounts[index]
                    discount.items = viewModel.selectedItems
                    viewModel.selectedDiscounts[index] = discount
                }
                dismiss()
            }) {
                Text("완료")
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .frame(width: UIScreen.main.bounds.width - 48, height: 60)
            .background(Color.lightPurple)
            .cornerRadius(8)
        }
        .background(Color.colavoPurple)
    }
}

struct DiscountRow: View {
    let discount: Discount
    @Binding var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(discount.name)
                        .foregroundColor(Color.darkGray)
                        .font(.system(size: 16))
                        .fontWeight(.medium)
                        .lineLimit(2)
                        .truncationMode(.tail)
                    Text(discount.getDiscountPercent())
                        .foregroundColor(.colavoPink)
                        .font(.system(size: 14))
                }
                Spacer()
                Image("done")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(isSelected ? .colavoPurple : .white)
                    .frame(width: 24, height: 24, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .onTapGesture {
                isSelected.toggle()
            }
            
            LineView(isDotted: false)
                .frame(height: 1, alignment: .bottom)
                .background(Color.lightGray)
        }
    }
}
