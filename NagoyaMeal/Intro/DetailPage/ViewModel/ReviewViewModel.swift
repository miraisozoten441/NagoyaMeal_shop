//
//  ReviewViewModel.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/12.
//

import SwiftUI

class ReviewViewModel: ObservableObject {
    @Published var reviews: [Reviews] = []
    
    func fetchReviews(shopId: String) async {
        
        print("全件取得")
        guard let url = URL(string: "\(CommonUrl.url)api/shop/shop/reviews/reviews/\(shopId)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedReviews = try JSONDecoder().decode([Reviews].self, from: data)
                    DispatchQueue.main.async {
                        self.reviews = decodedReviews
                    }
                } catch {
                    print("Failed to decode JSON: \(error)")
                }
            }
        }.resume()
        
        
    }
}

