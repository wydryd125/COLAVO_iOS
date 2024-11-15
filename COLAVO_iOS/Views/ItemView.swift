//
//  ItemView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI
import Combine

struct ItemView: View {
    @EnvironmentObject private var viewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                navigationView
                itemListView
                completeButtonView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white)
        }
    }
    
    private var navigationView: some View {
        ZStack {
            Button(action: {
                dismiss()
            }) {
                Image("dismiss")
                    .renderingMode(.template)
                    .foregroundColor(.midGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text("시술메뉴")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
    }
    
    private var itemListView: some View {
        ScrollView(showsIndicators: true) {
            Spacer()
                .frame(height: 16)
            LazyVStack(spacing: 24) {
                ForEach(viewModel.itemsData?.sortedItems() ?? [], id: \.id) { item in
                    let code = viewModel.itemsData?.currencyCode ?? .kr
                    ItemRow(item: item, code: code, isSelected: Binding(
                        get: {
                            viewModel.selectedItems.contains { $0.id == item.id }
                        },
                        set: { _ in
                            viewModel.toggleItemSelection(item: item)
                        }
                    ))
                }
            }
            .padding(.horizontal, 24)
        }
    }
    
    private var completeButtonView: some View {
        VStack(spacing: 12) {
            Spacer()
                .frame(height: 8)
            Text("서비스를 선택하세요(여러개 선택 가능)")
                .font(.system(size: 12))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
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

struct ItemRow: View {
    let item: Item
    let code: CurrencyCode
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .foregroundColor(Color.darkGray)
                    .font(.system(size: 16))
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .truncationMode(.tail)
                Text(item.price.formattedCurrency(code: code))
                    .foregroundColor(.blueGray)
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
        .contentShape(Rectangle())
        .onTapGesture {
            isSelected.toggle()
        }
    }
}
