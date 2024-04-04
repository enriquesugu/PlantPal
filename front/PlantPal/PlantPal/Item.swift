//
//  Item.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
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
