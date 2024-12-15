//
//  Genres.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/11/25.
//

import SwiftUI

struct Genres: Codable, Identifiable, Equatable {
    let id: String
    let genre_name: String
    
}

extension Genres {
    static var MOCK_GENRE: [Genres] = [
       .init(id: "1", genre_name: "ひつまぶし"),
    ]
}
