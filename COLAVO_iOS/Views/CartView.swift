//
//  CartView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @State private var isShowItemView = false
    @State private var isShowDiscountView = false
    @State private var showDiscountId: UUID?
    
    var body: some View {
        NavigationStack {
            VStack() {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    navigationView
                    addButtonsView
                    if viewModel.selectedItems.isEmpty && viewModel.selectedDiscounts.isEmpty {
                        Text("시술 선택해주세요.")
                            .foregroundColor(.midGray.opacity(0.6))
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .padding(.top, -16)
                            .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        ScrollView(showsIndicators: false) {
                            itemListView
                            discountListView
                        }
                    }
                    nextButtonView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(viewModel.isLoading ? Color.lightPurple : Color.white)
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
                    isShowItemView = true
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
                .fullScreenCover(isPresented: $isShowItemView) {
                    ItemView()
                        .environmentObject(viewModel)
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
                    DiscountView()
                        .environmentObject(viewModel)
                }
            }
            .background(Color.white)
            LineView(isDotted: true)
        }
        .padding(.horizontal, 24)
    }
    
    private var itemListView: some View {
        LazyVStack(spacing: 24) {
            ForEach(viewModel.selectedItems) { item in
                HStack() {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                            .foregroundColor(.pupleGray)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Text(item.getAmount().formattedCurrency(code: viewModel.itemsData?.currencyCode ?? .kr))
                            .foregroundColor(.blueGray)
                            .font(.system(size: 14))
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 8) {
                        Button(action: {
                            viewModel.removeItem(item: item)
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
                            viewModel.addItem(item: item)
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
        .padding(.top, viewModel.selectedItems.isEmpty ? 0 : 16)
        .padding(.horizontal, 24)
    }
    
    private var discountListView: some View {
        LazyVStack(spacing: 24) {
            ForEach(viewModel.selectedDiscounts) { discount in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(discount.name)
                            .foregroundColor(.pupleGray)
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Text(viewModel.getDiscountItemList(discount: discount))
                            .foregroundColor(.midGray)
                            .font(.system(size: 12))
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Spacer().frame(height: 2)
                        Text(viewModel.getDiscountAmount(discount: discount))
                            .foregroundColor(.colavoPink)
                            .font(.system(size: 14))
                    }
                    Spacer()
                    Button(action: {
                        if !discount.items.isEmpty {
                            showDiscountId = discount.id
                        }
                    }) {
                        if !viewModel.selectedItems.isEmpty {
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
                    }
                    .frame(width: 88, height: 48, alignment: .trailing)
                    .sheet(isPresented: Binding(
                        get: { showDiscountId == discount.id },
                        set: { isPresented in
                            if !isPresented {
                                showDiscountId = nil
                            }
                        }
                    )) {
                        SelectedDiscountView(discount: discount)
                            .presentationDetents([.medium, .large])
                            .presentationDragIndicator(.hidden)
                            .environmentObject(viewModel)
                    }
                }
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
            }
        }
        .padding(.top, viewModel.selectedItems.isEmpty ? 0 : 16)
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
                Text(viewModel.getFinalAmount())
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
