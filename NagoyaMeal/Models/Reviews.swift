//
//  Reviews.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/12.
//

import Foundation

struct Reviews: Codable, Identifiable {

    
    let id: String
    let user_id: String
    let user_name: String
    let review_point: Int
    let review_body: String
    let review_createDate: String
    let review_updateDate: String

    
}

extension Reviews {
    static var MOCK_REVIEWS: [Reviews] = [
        .init(id: "1", user_id: "1", user_name: "田中", review_point: 5, review_body: "おいしい", review_createDate: "2024-12-02", review_updateDate: "")
    ]
}
