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
    @State private var selectedPlant: String?
    @Binding var plants: [Plant]

    var body: some View {
        VStack {
            Text("Select a Plant to Add:")
                .font(.title)
                .padding()
            
            Button(action: {
                self.selectedPlant = "Passionfruit"
                self.addPlant()
            }) {
                Text("Passionfruit")
                    .padding()
            }
            
            Button(action: {
                self.selectedPlant = "Strawberry"
                self.addPlant()
            }) {
                Text("Strawberry")
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarTitle("Add Plant")
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
