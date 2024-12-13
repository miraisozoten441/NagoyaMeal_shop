//
//  Tab.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/25.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case lists = "一覧から探す"
    case maps = "マップから探す"
    
    var systemImg: String {
        switch self {
        case .lists: return "list.bullet"
        case .maps: return "map"
        }
    }
}
