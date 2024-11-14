//
//  CartView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI

struct CartView: View {
    @StateObject private var cartManager = CartManager.shared
    @ObservedObject private var viewModel = CartViewModel()
    @State private var isShowingTreatmentView = false
    @State private var isShowingDiscountView = false
    
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
                    isShowingTreatmentView = true
                }) {
                    HStack {
                        Image("add")
                            .renderingMode(.template)
                            .foregroundColor(.midGray)
                            .frame(width: 16, height: 16)
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
                .fullScreenCover(isPresented: $isShowingTreatmentView) {
                    if let itemsData = viewModel.itemsData {
                        TreatmentView(itemList: itemsData.sortedItems())
                    }
                }
                
                Button(action: {
                    isShowingDiscountView = true
                }) {
                    HStack {
                        Image("add")
                            .renderingMode(.template)
                            .foregroundColor(.midPink)
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
                .fullScreenCover(isPresented: $isShowingDiscountView) {
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
            Spacer().frame(height: 8)
            ForEach(cartManager.selectedTreatments) { item in
                HStack() {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .foregroundColor(.pupleGray)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Text(item.price.formattedCurrency())
                            .foregroundColor(.blueGray)
                            .font(.system(size: 14))
                    }
                    Spacer()
                    Button(action: {
                        print("아이템 클릭")
                    }) {
                        HStack(spacing: 0) {
                            Text("1")
                                .foregroundColor(.blueGray)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                            
                            Image("arrowDown")
                                .renderingMode(.template)
                                .foregroundColor(.midGray)
                                .offset(x: -2, y: 2)
                        }
                    }
                    .frame(width: 40, height: 32, alignment: .trailing)
                    .background(Color.bgGray)
                    .cornerRadius(24)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var discountListView: some View {
        LazyVStack(spacing: 24) {
            Spacer().frame(height: 4)
            ForEach(cartManager.selectedDiscounts) { discount in
                HStack() {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(discount.name)
                            .foregroundColor(.pupleGray)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Text(cartManager.getDiscountItemList())
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
                        print("아이템 클릭")
                    }) {
                        HStack(spacing: 0) {
                            Text("수정")
                                .foregroundColor(.blueGray)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                            
                            Image("arrowDown")
                                .renderingMode(.template)
                                .foregroundColor(.midGray)
                                .offset(x: -2, y: 2)
                        }
                    }
                    .frame(width: 60, height: 32, alignment: .trailing)
                    .background(Color.bgGray)
                    .cornerRadius(24)
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 24)
    }
    
    private var nextButtonView: some View {
        VStack(spacing: 20) {
            LineView(isDotted: false, lineWidth: 0.6)
            
            HStack {
                Text("합계")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.blueGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text(cartManager.getTotalAmount())
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
