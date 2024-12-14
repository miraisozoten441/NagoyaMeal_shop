//
//  ShopListCells.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/28.
//

import SwiftUI

struct ShopListCells: View {
    
    @ObservedObject var svm: ShopViewModel
    let genre: String = "ひつまぶし"
    let currentUser: String
    let genreId: String
    let openingTimes: String = "24時間"
    
    
    var body: some View {
        ScrollView{
            ForEach(svm.favoritesShops){ shop in
                
                NavigationLink(destination: DetailPageView(svm: svm, shop: shop, currentUser: currentUser)){
                    
                    
                    
                    VStack{
                        HStack{
                            Text(genre)
                                .frame(width: 100)
                                .foregroundStyle(.white)
                                .background(.mainBg)
                            
                            Spacer()
                        }
                        
                        //お店の名前
                        HStack{
                            Text(shop.shop_name)
                            
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if shop.isFavorite {
                                Button {
                                    delete(shop: shop)
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .font(.title)
                                        .foregroundStyle(.pink)
                                }
                                .padding(.horizontal)
                            } else {
                                Button{
                                    Task {
                                        try await svm.createFavorites(shopId: shop.id, userId: currentUser) {data in
                                            await MainActor.run {
                                                
                                            }
                                        }
                                        await svm.fetchFavorites(userId: currentUser)
                                        await svm.fetchFavoritesShops()
                                    }
                                } label: {
                                    Image(systemName: "heart")
                                        .font(.title)
                                        .foregroundStyle(.primary)
                                }
                                .padding(.horizontal)
                            }
                            
                            
                        }
                        .font(.title3)
                        //評価 & 距離
                        HStack{
                            Text(String(format: "%.1f", shop.shop_review))
                            StarRating(rating: shop.shop_review)
                            Spacer()
                            
                        }
                        
                        //営業状態
                        HStack{
                            Text(shop.shop_now_open ? "営業中": "休業中")
                                .lineLimit(1)
                            Text(openingTimes)
                            Spacer()
                        }
                        
                    }
                    .padding(.leading)
                    
                    
                    .foregroundStyle(Color(.label))
                    .onAppear{
                        Task{
                            await svm.fetchShops(genreId: genreId)
                            await svm.fetchFavorites(userId: currentUser)
                            await svm.fetchFavoritesShops()
                        }
                        
                    }
                    .padding(.vertical, 8)
                }
                
                
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.gray)
            }
        }
        
    }
    
    func delete(shop: FavoriteShops){
        Task {
            if let df = svm.fs.first(where: { $0.shopId == shop.id }) {
                try await svm.deleteFavorites(favoriteId: df.favoriteId) { data in
                    await MainActor.run {
                        print("削除が完了")
                    }
                }
                svm.fs = []
                await svm.fetchFavorites(userId: currentUser)
                await svm.fetchFavoritesShops()
                
            } else {
                print("一致するFavoriteShopが見つかりませんでした")
            }
        }
    }
}

#Preview {
    //    ShopListCells(shopList: Shops.MOCK_SHOP, fvm: FavoriteViewModel = FavoriteViewModel())
}
