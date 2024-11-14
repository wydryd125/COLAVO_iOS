//
//  TreatmentView.swift
//  COLAVO_iOS
//
//  Created by wjdyukyung on 11/12/24.
//

import SwiftUI
import Combine

struct TreatmentView: View {
    let itemList: [Item]
    @State private var selectedItems = [Item]()
    @StateObject private var cartManager = CartManager.shared
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
    
    //수정 네비게이션 커스텀 뷰로 만들기
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
            Text("시술메뉴")
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
    
    private var itemListView: some View {
        ScrollView(showsIndicators: true) {
            Spacer()
                .frame(height: 16)
            LazyVStack(spacing: 24) {
                ForEach(itemList,  id: \.id) { item in
                    ItemRow(item: item, isSelected: Binding(
                        get: {
                            selectedItems.contains { $0.id == item.id }
                        },
                        set: { _ in
                            if !selectedItems.contains(where: { $0.id == item.id }) {
                                selectedItems.append(item)
                            } else {
                                selectedItems.removeAll { $0.id == item.id }
                            }
                        }
                    ))
                }
            }
            .padding(.horizontal, 24)
            .onAppear {
                selectedItems = cartManager.selectedTreatments
            }
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
                for idx in selectedItems.indices {
                    selectedItems[idx].isDiscounted = true
                }
                cartManager.selectedTreatments = selectedItems
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
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
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
            
            Image("done")
                .renderingMode(.template)
                .foregroundColor(isSelected ? .colavoPurple : .white)
                .frame(width: 32, height: 28, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            isSelected.toggle()
        }
    }
}
