//
//  ShopMapCells.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/28.
//

import SwiftUI

struct ShopMapCells: View {
    @ObservedObject var gvm: GenreViewModel
    @ObservedObject var svm: ShopViewModel
    let currentUser: String
    let openingTimes: String = "24時間"
    
    @State private var isDetail = false
    
    @Binding var isSheet: Bool
    @Binding var isOpen: Bool
    
    var body: some View {
        ScrollView{
            if isOpen{
                if svm.favoritesShops.filter({ $0.shop_now_open }).isEmpty{
                    Text("店舗がありません")
                        .padding()
                } else{
                    ForEach(svm.favoritesShops.filter { $0.shop_now_open }){ shop in
                        
                        VStack{
                            HStack{
                                if shop.shop_now_open {
                                    Text("営業中")
                                        .padding(3)
                                        .foregroundStyle(.white)
                                        .background(.accent)
                                }
                                
                                ForEach(shop.genres, id: \.id) { genre in
                                    Text(genre.genre_name)
                                        .padding(3)
                                        .foregroundStyle(.white)
                                        .background(.mainBg)
                                }
                                
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
                                Text("営業時間:")
                                Text(svm.getTimes(times: shop.works_times))
                                Spacer()
                            }
                            
                        }
                        .padding(.leading)
                        .foregroundStyle(Color(.label))
                        .padding(.vertical, 8)
                        .onTapGesture {
                            svm.selectShop = shop
                            isDetail = true
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray)
                    }
                }
            } else {
                if svm.favoritesShops.isEmpty{
                    Text("店舗がありません").padding()
                } else{
                    ForEach(svm.favoritesShops){ shop in
                        
                        VStack{
                            HStack{
                                if shop.shop_now_open {
                                    Text("営業中")
                                        .padding(3)
                                        .foregroundStyle(.white)
                                        .background(.accent)
                                }
                                
                                ForEach(shop.genres, id: \.id) { genre in
                                    Text(genre.genre_name)
                                        .padding(3)
                                        .foregroundStyle(.white)
                                        .background(.mainBg)
                                }
                                
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
                                Text("営業時間:")
                                Text(svm.getTimes(times: shop.works_times))
                                Spacer()
                            }
                            
                        }
                        .padding(.leading)
                        .foregroundStyle(Color(.label))
                        .padding(.vertical, 8)
                        .onTapGesture {
                            svm.selectShop = shop
                            isDetail = true
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.gray)
                    }
                }
            }
            
        }
        .fullScreenCover(isPresented: $isDetail) {
            
            DetailPageView(svm: svm, shop: svm.selectShop!, currentUser: currentUser)
            
        }
        .onAppear{
            if let selectGenreId = gvm.getGenreId(){
                Task{
                    let sortKey = svm.getSortKey(from: svm.selectSort)
                    
                    await svm.fetchShops(genreId: selectGenreId, sortKey: sortKey)
                    await svm.fetchFavorites(userId: currentUser)
                    
                    svm.convertToFavoriteShops()
                    
                    await svm.fetchFavoritesShops()
                    
                    
                    
                }
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

//#Preview {
//    ShopMapCells(gvm: GenreViewModel(), svm: ShopViewModel(), currentUser: "test2", isSheet: )
//}
