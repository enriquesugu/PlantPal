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
        ScrollView {
            if plants.isEmpty {
                Text("You haven't got any plants yet")
                    .foregroundColor(.gray)
            } else {
                VStack {
                    ForEach(Array(plants.enumerated()), id: \.offset) { index, plant in
                        NavigationLink(destination: Plant(name: plant.self.name, imageName: plant.self.imageName)) {
                            Text(plant.name)
                                .foregroundColor(.black)
                                .padding(20)
                                .background(
                                    Capsule().fill(Color.green.opacity(0.1 * (Double(index) + 1))).frame(minWidth: 300)
                                )
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
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
