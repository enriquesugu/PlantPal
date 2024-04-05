//
//  Title.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI

struct PlantPage: View {

    @Binding var plants: [Plant]
    
    var body: some View {
        ZStack {
            //LinearGradient(gradient: Gradient(colors: [.clear, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
            ScrollView {
                VStack {
                    ForEach(plants, id: \.self) { plant in
                        NavigationLink(value: plant) {
                            Text(plant.name)
                        }
                        .foregroundColor(Color(hex: 0xdad7cd))
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0x344e41)))
                    }
                }
                .navigationTitle("PlantPal")
                .navigationDestination(for: Plant.self) { value in
                    Plant(name: value.name, imageName: value.imageName)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

/*struct PlantPage: View {
    @Binding var plants: [Plant]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Garden")
                    .font(.title)
                
                List {
                    ForEach(plants, id: \.self) { plant in
                        NavigationLink(destination: Plant(name: plant.name, imageName: plant.imageName)) {
                            Text(plant.name)
                        }
                    }
                }
            }
            .navigationBarTitle("Your Garden")
        }
    }
}*/
