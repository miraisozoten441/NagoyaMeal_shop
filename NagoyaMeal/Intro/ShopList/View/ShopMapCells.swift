//
//  ShopMapCells.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/28.
//

import SwiftUI

struct ShopMapCells: View {
    let shopList: [Shops]
    
    @State private var isShopSheet: Bool = false
    
    var body: some View {
        ScrollView{
            ForEach(shopList){ shop in
                
                MapSheetCell(genre: "ひつまぶし", shopName: shop.shop_name, review: shop.shop_review, distance: 300, status: shop.shop_now_open, openingTimes: "24時間")
                    
                    .onTapGesture {
                        isShopSheet.toggle()
                    }
                
                
                Rectangle()
                    .frame(height: 6)
                    .foregroundColor(.gray)
            }
        }
        .fullScreenCover(isPresented: $isShopSheet) {
//            DetailPageView(shop: Shops)
        }
    }
}

#Preview {
    ShopMapCells(shopList: Shops.MOCK_SHOP)
}
