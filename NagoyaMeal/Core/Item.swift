//
//  Item.swift
//  NagoyaMeal
//
//  Created by 中島瑠斗 on 2024/10/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
