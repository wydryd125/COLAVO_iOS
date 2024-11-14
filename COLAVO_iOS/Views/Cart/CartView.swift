//
//  CartView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI

struct CartView: View {
    @ObservedObject private var cartManager = CartManager.shared
    @ObservedObject private var viewModel = CartViewModel()
    @State private var isShowTreatmentView = false
    @State private var isShowDiscountView = false
    @State private var showDiscountId: UUID? = nil
    
    var body: some View {
        NavigationStack {
            VStack() {
                navigationView
                addButtonsView
                ScrollView(showsIndicators: false) {
                    itemListView
                    discountListView
                }
                nextButtonView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
        }
    }
    
    private var navigationView: some View {
        VStack {
            Text("정유경")
                .font(.headline)
                .foregroundColor(.black)
            Text(Date().formattedString)
                .font(.subheadline)
                .foregroundColor(.midGray)
        }
    }
    
    private var addButtonsView: some View {
        VStack(spacing: 16) {
            Spacer()
                .frame(height: 8)
            HStack(spacing: 8) {
                Button(action: {
                    isShowTreatmentView = true
                }) {
                    HStack {
                        Image("add")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.midGray)
                            .frame(width: 20, height: 20)
                        Text("시술")
                            .foregroundColor(.blueGray)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 48)
                    .background(Color.bgGray)
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
                .fullScreenCover(isPresented: $isShowTreatmentView) {
                    if let itemsData = viewModel.itemsData {
                        TreatmentView(itemList: itemsData.sortedItems())
                    }
                }
                
                Button(action: {
                    isShowDiscountView = true
                }) {
                    HStack {
                        Image("add")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.midPink)
                            .frame(width: 20, height: 20)
                        Text("할인")
                            .foregroundColor(.colavoPink)
                            .font(.body)
                            .fontWeight(.medium)
                    }
                    .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 48)
                    .background(Color.lightPink)
                    .cornerRadius(16)
                }
                .buttonStyle(PlainButtonStyle())
                .fullScreenCover(isPresented: $isShowDiscountView) {
                    if let itemsData = viewModel.itemsData {
                        DiscountView(discountList: itemsData.sortedDiscount())
                    }
                }
            }
            .background(Color.white)
            LineView(isDotted: true)
        }
        .padding(.horizontal, 24)
    }
    
    private var itemListView: some View {
        LazyVStack(spacing: 24) {
            ForEach(cartManager.selectedTreatments) { item in
                HStack() {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .foregroundColor(.pupleGray)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Text(item.getAmountString())
                            .foregroundColor(.blueGray)
                            .font(.system(size: 14))
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 8) {
                        Button(action: {
                            cartManager.removeItem(item: item)
                        }) {
                            Image("minus")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.midGray)
                                .frame(width: 16, height: 16)
                        }
                        
                        Text("\(item.count)")
                            .foregroundColor(.darkGray)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                        
                        Button(action: {
                            cartManager.addItem(item: item)
                        }) {
                            Image("plus")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.midGray)
                                .frame(width: 16, height: 16)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
    }
    
    private var discountListView: some View {
        LazyVStack(spacing: 24) {
            ForEach(cartManager.selectedDiscounts) { discount in
                HStack() {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(discount.name)
                            .foregroundColor(.pupleGray)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Text(cartManager.getDiscountItemList(discount: discount))
                            .foregroundColor(.midGray)
                            .font(.system(size: 12))
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Spacer().frame(height: 2)
                        Text(cartManager.getDiscountAmount(discount: discount))
                            .foregroundColor(.colavoPink)
                            .font(.system(size: 14))
                    }
                    Spacer()
                    Button(action: {
                        showDiscountId = discount.id
                    }) {
                        HStack(spacing: 0) {
                            Text("할인 리스트")
                                .foregroundColor(.pupleGray)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                            
                            Image("arrowBottom")
                                .renderingMode(.template)
                                .foregroundColor(.midGray)
                        }
                    }
                    .frame(width: 88, height: 48, alignment: .trailing)
                    .sheet(isPresented: Binding(
                        get: { showDiscountId != nil },
                        set: { isPresented in
                            if !isPresented { showDiscountId = nil }
                        }
                    )) {
                        if let discountId = showDiscountId,
                           let selectedDiscount = cartManager.selectedDiscounts.first(where: { $0.id == discountId }) {
                            DiscountListView(discount: selectedDiscount)
                                .presentationDetents([.medium, .large])
                                .presentationDragIndicator(.hidden)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 24)
    }
    
    private var nextButtonView: some View {
        VStack(spacing: 20) {
            LineView(isDotted: false)
            
            HStack {
                Text("합계")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.blueGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text(cartManager.getFinalAmount())
                    .font(.system(size: 28))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 28)
            
            Button(action: {
                print("다음 클릭됨")
            }) {
                Text("다음")
                    .foregroundColor(.white)
                    .font(.body)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .frame(width: UIScreen.main.bounds.width - 48, height: 52)
            .background(Color.colavoPurple)
            .cornerRadius(8)
        }
    }
}
