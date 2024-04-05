//
//  Title.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI

struct PlantPage: View {

    var plants: [Plant] = [.init(name: "Cactus", imageName: "Cactus"), .init(name: "Daisy", imageName: "Daisy"), .init(name: "Tomato", imageName: "Tomato")]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.clear, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
            VStack {
                Text("Hello world")
                
                ForEach(plants, id: \.self) { plant in
                    NavigationLink(value: plant) {
                        Text(plant.name)
                    }
                }
            }
            .navigationTitle("Your Garden")
            .navigationDestination(for: Plant.self) { value in
                Plant(name: value.name, imageName: value.imageName)
            }
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct PlantTest: Hashable {
    let name: String
}
