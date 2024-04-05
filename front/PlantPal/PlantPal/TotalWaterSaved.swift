//
//  TotalWaterSaved.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 6/4/2024.
//

import Foundation

// singleton class
class TotalWaterSaved: ObservableObject {
    static let shared = TotalWaterSaved()
    @Published var totalWaterSaved = 0.0
    
    private init() {
        
    }
    
    func updateTotalWaterSaved(amount: Double) {
        totalWaterSaved += amount
    }
}
