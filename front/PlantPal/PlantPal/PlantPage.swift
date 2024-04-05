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
                    ForEach(plants, id: \.self) { plant in
                        NavigationLink(value: plant) {
                            Text(plant.name)
                        }
                        .foregroundColor(Color.black)
                            .padding(20)
                            .background(Capsule(style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).fill(Color.green).opacity(0.2))
                    }
                
                }
                .navigationDestination(for: Plant.self) { value in
                    Plant(name: value.name, imageName: value.imageName)
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
