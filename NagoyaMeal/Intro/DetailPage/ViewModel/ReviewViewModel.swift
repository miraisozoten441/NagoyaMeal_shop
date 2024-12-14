//
//  ReviewViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/12.
//

import SwiftUI

class ReviewViewModel: ObservableObject {
    @Published var reviews: [Reviews] = []
    @Published var myReview: Reviews?
    @Published var inputText: String = ""
    @Published var raiting: Int = 0
    
    
    ///レビュー取得
    func fetchReviews(shopId: String, currentUser: String) async {
        guard let url = URL(string: "\(CommonUrl.url)api/shop/shop/reviews/reviews/\(shopId)") else {
            print("Invalid URL")
            return
        }

        let api = APIConnect(url: url)
        do {
            let data = try await api.getRequest()
            let decodedReviews = try JSONDecoder().decode([Reviews].self, from: data)
            //print("API Response: \(decodedReviews)")
            await MainActor.run {
                self.reviews = decodedReviews.filter { $0.user_id != currentUser }
                self.myReview = decodedReviews.first(where: { $0.user_id == currentUser })
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    ///レビュー投稿
    func createReview(shopId: String, userId: String, completion: @escaping (Reviews) async -> Void) async throws {
        //print("レビュー投稿")
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/reviews/create")!)
        
        let newReviewData = CreateReviewRequest(
            shop_id: shopId,
            user_id: userId,
            review_point: self.raiting,
            review_body: self.inputText
        )
        
        do {
            let json = try JSONEncoder().encode(newReviewData)
            try await api.postRequest(form: json)
        } catch {
            print("Networking error: \(error)")
        }
    }
    
    ///レビュー更新
    func updateReview(id: String, completion: @escaping (Reviews) async -> Void) async throws {
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/reviews/update")!)
        
        let updateData = UpdateReviewRequest(
            id: id,
            review_point: self.raiting,
            review_body: self.inputText
        )
        
        do {
            let json = try JSONEncoder().encode(updateData)
            try await api.postRequest(form: json)
        } catch {
            print("Networking error: \(error)")
        }
    }
    
    ///レビュー削除
    func deleteReview(id: String, completion: @escaping (Reviews) async -> Void) async throws {
        let api = APIConnect(url: URL(string: "\(CommonUrl.url)api/shop/shop/reviews/delete/\(id)")!)
        do {
            try await api.postRequest(form: Data())
        } catch {
            print("Networking error: \(error)")
        }
    }
}

///投稿用
struct CreateReviewRequest: Codable {
    let shop_id: String
    let user_id: String
    let review_point: Int
    let review_body: String
}
///更新用
struct UpdateReviewRequest: Codable {
    let id: String
    let review_point: Int
    let review_body: String
}

