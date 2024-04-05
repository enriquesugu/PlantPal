//
//  Plant.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI

struct Plant: Hashable, View {
    let name: String
    let imageName: String
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.clear, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
            Text("\(name)")
        }
        .edgesIgnoringSafeArea(.all)
    }
}
