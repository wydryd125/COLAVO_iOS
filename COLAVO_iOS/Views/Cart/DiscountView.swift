//
//  DiscountView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI

struct DiscountView: View {
    @StateObject private var cartManager = CartManager.shared
    let discountList: [Discount]
    @State private var selectedDiscount = [Discount]()
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
                ForEach(discountList,  id: \.id) { item in
                    DiscountRow(discount: item, isSelected: Binding(
                        get: {
                            selectedDiscount.contains { $0.id == item.id }
                        },
                        set: { _ in
                            if !selectedDiscount.contains(where: { $0.id == item.id }) {
                                selectedDiscount.append(item)
                            } else {
                                selectedDiscount.removeAll { $0.id == item.id }
                            }
                        }
                    ))
                    .frame(height: 40)
                }
            }
            .padding(.horizontal, 24)
            .onAppear {
                selectedDiscount = cartManager.selectedDiscounts
            }
        }
    }
    
    private var completeButtonView: some View {
        VStack(spacing: 12) {
            Spacer()
                .frame(height: 8)
            Text("할인을 선택하세요(여러개 선택 가능)")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                for idx in selectedDiscount.indices {
                    selectedDiscount[idx].items = cartManager.selectedTreatments
                }
                cartManager.selectedDiscounts = selectedDiscount
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
            
            //마지막 라인 숨기기 수정
        }
    }
}
