//
//  Shops.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/11/28.
//

import SwiftUI

struct Shops: Codable, Identifiable, Equatable {
    let id: String
    let shop_name: String
    let shop_review: Float
    let shop_now_open: Bool
    let shop_address: String
    let shop_phoneNumber: String
    let genres: [Genres]
    let works_times: [WorksTimes]
    
}

extension Shops {
    static var MOCK_SHOP: [Shops] = [
        .init(
            id: "1",
            shop_name: "ひつまぶし",
            shop_review: 4.5,
            shop_now_open: true,
            shop_address: "名古屋市中区",
            shop_phoneNumber: "xxx-xxxx-xxxx",
            genres: [
                Genres(id: "1", genre_name: "和食"),
                Genres(id: "2", genre_name: "ひつまぶし")
            ],
            works_times: [
                WorksTimes(worksTime_week: "月", worksTime_openTime: "11:00", worksTime_closeTime: "15:00")
            ]
        )
    ]
}

struct WorksTimes: Codable, Equatable {
    let worksTime_week: String
    let worksTime_openTime: String
    let worksTime_closeTime: String
}

extension WorksTimes {
    static var MOCK_WORKS: [WorksTimes] = [
        .init(worksTime_week: "月", worksTime_openTime: "11:00", worksTime_closeTime: "12:00")
    ]
}
