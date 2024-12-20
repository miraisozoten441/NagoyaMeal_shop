//
//  ShopViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/11/21.
//

import SwiftUI

class ShopViewModel: ObservableObject {
    @Published var shops: [Shops] = []
    @Published var favoritesShops: [FavoriteShops] = []
    @Published var fs: [FavoriteShop] = []
    @Published var favorites: [Favorites] = []
    @Published var selectSort: String = "登録順"
    @Published var selectShop: FavoriteShops?
    
    
    
    ///お気に入り取得
    func fetchFavorites(userId: String) async {
        //print("お気に入り取得")
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/favorites/get/\(userId)")!)
        do {
            
            let data = try await api.getRequest()
            
            let favorite = try JSONDecoder().decode([Favorites].self, from: data)
            //print("API Response: \(favorite)")
            await MainActor.run {
                self.favorites = favorite
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    
    ///お店取得
    func fetchShops(genreId: String = "", sortKey: String = "dafault") async {
        var urlString = "\(CommonUrl.url)api/shop/shop/shops/shops"
        if !genreId.isEmpty && genreId != "0"  {
            urlString += "/\(genreId)"
        }
        
        urlString += "?sort_key=\(sortKey)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let api = APIConnect(url: url)
        do {
            let data = try await api.getRequest()
            let decodedShops = try JSONDecoder().decode([Shops].self, from: data)
            //print("API Response: \(decodedShops)")
            await MainActor.run {
                self.shops = decodedShops
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    ///取得したお店がお気に入り登録されているかを確認
    @MainActor
    func fetchFavoritesShops() async {
        fs = []
            let favoriteDict = Dictionary(uniqueKeysWithValues: favorites.map { ($0.shop_id, $0.id) })
            await MainActor.run {
                for index in favoritesShops.indices {
                    if let favoriteId = favoriteDict[favoritesShops[index].id] {
                        favoritesShops[index].isFavorite = true
                        let favo = FavoriteShop(favoriteId: favoriteId, shopId: favoritesShops[index].id)
                        fs.append(favo)
                    } else {
                        favoritesShops[index].isFavorite = false
                    }
                }
            }
        }
    
    
    var createForm: CreateFavorite = .init()
    
    ///お気に入り登録
    func createFavorites(shopId: String, userId: String, completion: @escaping (CreateFavorite) async -> Void) async throws {
        //print("お気に入り登録")
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
        
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/favorites/delete/\(favoriteId)")!)
        do {
            let json = try JSONEncoder().encode(deleteForm)
            try await api.postRequest(form: json)
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
    
    
    func convertToFavoriteShops() {
        favoritesShops = self.shops.map { shop in
            FavoriteShops(
                id: shop.id,
                shop_name: shop.shop_name,
                shop_review: shop.shop_review,
                shop_now_open: shop.shop_now_open,
                shop_address: shop.shop_address,
                shop_phoneNumber: shop.shop_phoneNumber,
                genres: shop.genres,
                works_times: shop.works_times,
                isFavorite:  false
            )
        }
    }
    
    ///曜日の取得
    func getShortWeekdayInJapan() -> String {
        let weekdays = ["日", "月", "火", "水", "木", "金", "土"] // 日本語の短縮曜日名
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")! // 日本時間のタイムゾーン
        
        let weekdayIndex = calendar.component(.weekday, from: Date()) - 1 // 日曜日: 1, 月曜日: 2, ...
        return weekdays[weekdayIndex]
    }
    
    /// 営業時間の取得
    func getTimes(times: [WorksTimes]) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        
        let today = formatter.string(from: Date())

        let todayTimes = times.filter{ $0.worksTime_week == today }
        
        if !todayTimes.isEmpty {
            var resultTime = ""
            for time in todayTimes {
                resultTime += "\(time.worksTime_openTime) ~ \(time.worksTime_closeTime) "
            }
            return resultTime
        } else {
            return "定休日"
        }
    }
    
    func getAllTimes(times: [WorksTimes]) -> String {
        let week = ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
        var result = ""
        
        if !times.isEmpty {
            for w in week {
                let todayTimes = times.filter{ $0.worksTime_week == w }
                
                if !todayTimes.isEmpty {
                    var resultTime = ""
                    for time in todayTimes {
                        resultTime += "\(time.worksTime_openTime) ~ \(time.worksTime_closeTime) "
                    }
                    
                    result += "\(w): \(resultTime) \n"
                }
                else {
                    result += "\(w): 定休日 \n"
                }
            }
        } else {
            return "休業中"
        }
        return result
    }
    
    
    /// ソートキーを選択されたリストから取得
    func getSortKey(from sortName: String) -> String {
        switch sortName {
        case "口コミ順":
            return "comments"
        case "人気順":
            return "favorites"
        case "評価順":
            return "review"
        case "お店名順":
            return "name"
        default:
            return "default"
        }
    }
    
    
    
    
}
struct FavoriteShops: Identifiable, Equatable {
    let id: String
    let shop_name: String
    let shop_review: Float
    let shop_now_open: Bool
    let shop_address: String
    let shop_phoneNumber: String
    let genres: [Genres]
    let works_times: [WorksTimes]
    var isFavorite: Bool
}
