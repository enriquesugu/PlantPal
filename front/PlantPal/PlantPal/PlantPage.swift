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
            LinearGradient(gradient: Gradient(colors: [.clear, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
            VStack {
                Text("Hello world")
                
                ForEach(plants, id: \.self) { plant in
                    NavigationLink(destination: Plant(name: plant.name, imageName: plant.imageName)) {
                        Text(plant.name)
                    }
                }            }
            .navigationTitle("Your Garden")
            .navigationDestination(for: Plant.self) { value in
                Plant(name: value.name, imageName: value.imageName)
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
