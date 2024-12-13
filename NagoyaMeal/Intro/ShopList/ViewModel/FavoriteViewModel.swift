//
//  FavoriteViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/12.
//

import Foundation
import Observation

class FavoriteViewModel: ObservableObject {
    
    
    @Published var favorites: [Favorites] = []
    
    
    
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
}
