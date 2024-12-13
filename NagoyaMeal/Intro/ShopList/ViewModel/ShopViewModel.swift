//
//  ShopViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/11/21.
//

import SwiftUI

class ShopViewModel: ObservableObject {
    @Published var shops: [Shops] = []
    @Published var favoritesShops: [FavoriteShop] = []
    @Published var favorites: [Favorites] = []
    
    init(genreId: String, userId: String) {
        Task {
            await fetchShops(genreId: genreId)
            await fetchFavorites(userId: userId)
        }
    }
    
    
    ///お気に入り取得
    func fetchFavorites(userId: String) async {
        //print("お気に入り取得")
        guard let url = URL(string: "\(CommonUrl.url)api/shop/shop/favorites/get/\(userId)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedFavorites = try JSONDecoder().decode([Favorites].self, from: data)
                    DispatchQueue.main.async {
                        self.favorites = decodedFavorites
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
        
        
    }
    ///お店取得
    func fetchShops(genreId: String = "") async {
        if genreId == "" {
            //print("全件取得")
            guard let url = URL(string: "\(CommonUrl.url)api/shop/shop/shops/shops") else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodedShops = try JSONDecoder().decode([Shops].self, from: data)
                        DispatchQueue.main.async {
                            self.shops = decodedShops
                        }
                    } catch {
                        print("Failed to decode JSON: \(error)")
                    }
                }
            }.resume()
        } else {
            //print("ソート取得")
            guard let url = URL(string: "\(CommonUrl.url)api/shop/shop/shops/shops/\(genreId)") else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodedShops = try JSONDecoder().decode([Shops].self, from: data)
                        DispatchQueue.main.async {
                            self.shops = decodedShops
                        }
                    } catch {
                        print("Failed to decode JSON: \(error)")
                    }
                }
            }.resume()
            
            
        }
    }
    
    ///取得したお店がお気に入り登録されているかを確認
    func fetchFavoritesShops(shops: [Shops]) async {
        
        for favorite in self.favorites{
            for shop in shops {
                if favorite.shop_id == shop.id {
                    DispatchQueue.main.async {
                        let favoriteShop = FavoriteShop(favoriteId: favorite.id, shopId: shop.id)
                        self.favoritesShops.append(favoriteShop)
                    }
                }
            }
        }
        
        print("お気に入りのショップ取得完了")
        print(favoritesShops)
    }
    
    
    var createForm: CreateFavorite = .init()
    
    ///お気に入り登録
    func createFavorites(shopId: String, userId: String, completion: @escaping (CreateFavorite) async -> Void) async throws {
        print("お気に入り登録")
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/favorites/create/\(shopId)/\(userId)")!)
        do {
            let json = try JSONEncoder().encode(createForm)
            let res = try await api.postRequest(form: json)
            do {
                let favorite = try JSONDecoder().decode(CreateFavorite.self, from: res)
                await completion(favorite)
            } catch {
                print("Decoding error: \(error)")
            }
        } catch {
            print("Networking error: \(error)")
        }
        
    }
    
    var deleteForm: DeleteFavorite = .init()
    
    
    ///お気に入り削除
    func deleteFavorites(favoriteId: String, completion: @escaping (DeleteFavorite) async -> Void) async throws {
        print("お気に入り削除")
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/favorites/delete/\(favoriteId)")!)
        do {
            let json = try JSONEncoder().encode(deleteForm)
            let res = try await api.postRequest(form: json)
            do {
                let favorite = try JSONDecoder().decode(DeleteFavorite.self, from: res)
                await completion(favorite)
            } catch {
                print("Decoding error: \(error)")
            }
        } catch {
            print("Networking error: \(error)")
        }
    }
    
    
    
    
    
    struct CreateFavorite: Codable {
        var id: String = ""
        var shop_id: String = ""
        var user_id: String = ""
    }
    
    struct DeleteFavorite: Codable {
        var id: String = ""
    }
    struct FavoriteShop: Codable {
        var favoriteId: String
        var shopId: String
    }
}
