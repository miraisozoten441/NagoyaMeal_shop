//
//  Favorites.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/12/12.
//

import SwiftUI


struct Favorites: Codable, Identifiable {
    let id: String
    let user_id: String
    let shop_id: String
    let favorite_createDate: String
    
}

extension Favorites {
    
    static var MOCK_FACVORITE: [Favorites] = [
        .init(id: "1", user_id: "1", shop_id: "1", favorite_createDate: "1")
    ]
}

