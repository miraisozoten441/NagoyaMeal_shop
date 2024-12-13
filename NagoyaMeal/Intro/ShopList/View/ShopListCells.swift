//
//  ShopListCells.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/28.
//

import SwiftUI

struct ShopListCells: View {
    
    @ObservedObject var svm: ShopViewModel
    let currentUser: String
    
    var body: some View {
        ZStack{

            ScrollView{
                ForEach(svm.shops){ shop in
                    
                    NavigationLink(destination: DetailPageView(shop: shop)){
                        
                        ShopListCell(genre: "ひつまぶし", distance: 200, openingTimes: "24時間", shop: shop, svm: svm, currentUser: currentUser)
                            .foregroundStyle(Color(.label))
                            
                    }
                    
                    
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}

#Preview {
//    ShopListCells(shopList: Shops.MOCK_SHOP, fvm: FavoriteViewModel = FavoriteViewModel())
}
