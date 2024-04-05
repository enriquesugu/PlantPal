//
//  AddPlantPage.swift
//  PlantPal
//
//  Created by Enrique Sugunananthan on 5/4/2024.
//

import Foundation
import SwiftUI

struct AddPlantPage: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var plants: [Plant]
    @State private var selectedPlant: String?
    
    
    var body: some View {
        
        List {
            //AddPlantItem(plantName: "Mint")
            AddPlantItem(plantName: "Strawberry", selectedPlant: $selectedPlant)
            AddPlantItem(plantName: "Tomato", selectedPlant: $selectedPlant)
            AddPlantItem(plantName: "Passionfruit", selectedPlant: $selectedPlant)
        }
        
        .onChange(of: selectedPlant) { newVal in
            addPlant()
                
        }
    }
    
    func addPlant() {
        if let selectedPlant = selectedPlant {
            // Create a new plant instance based on the selected type
            let plant = Plant(name: selectedPlant, imageName: selectedPlant.lowercased())
            
            // Add the new plant to the plants array
            plants.append(plant)
            
            // Dismiss the AddPlantPage
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}
