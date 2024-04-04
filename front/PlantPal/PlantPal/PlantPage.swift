//
//  Title.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI

struct PlantPage: View {
    var titleSize: CGFloat
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
                VStack {
                    Section {
                        Text("PlantPal")
                    }
                        .font(.system(size: titleSize))
                    Section {
                        Text("Plant1")
                        Text("Plant2")
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
