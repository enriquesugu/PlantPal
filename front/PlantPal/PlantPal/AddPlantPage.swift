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
    @State private var squareMeters: String = ""
    
    var body: some View {
        VStack {
            List {
                AddPlantItem(plantName: "Strawberry", selectedPlant: $selectedPlant)
                AddPlantItem(plantName: "Tomato", selectedPlant: $selectedPlant)
                AddPlantItem(plantName: "Passionfruit", selectedPlant: $selectedPlant)
            }
            
            if selectedPlant != nil {
                TextField("Input square meters allocated for this plant", text: $squareMeters)
                    .keyboardType(.decimalPad) // Restricts input to numbers only
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            Button("Get Growing!", systemImage: "plus", action: {
                addPlant()
             })
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
        }
    }
    
    func addPlant() {
        guard let selectedPlant = selectedPlant,
              let squareMeters = Double(squareMeters) else {
            return
        }
        
        // Create a new plant instance based on the selected type and square meters
        let plant = Plant(name: selectedPlant, imageName: selectedPlant.lowercased(), squareMeters: squareMeters)
        
        // Add the new plant to the plants array
        plants.append(plant)
        
        // Dismiss the AddPlantPage
        presentationMode.wrappedValue.dismiss()
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}
