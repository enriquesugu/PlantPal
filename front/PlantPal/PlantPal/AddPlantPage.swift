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
        VStack {
            Text("Select a Plant to Add:")
                .font(.title)
                .padding()
            
            Button(action: {
                self.selectedPlant = "Passionfruit"
                self.addPlant()
            }) {
                HStack {
                    Image("passionfruit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Text("Passionfruit")
                        .padding()
                }
            }
            
            Button(action: {
                self.selectedPlant = "Strawberry"
                self.addPlant()
            }) {
                HStack {
                    Image("strawberry")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Text("Strawberry")
                        .padding()
                }
            }
            Button(action: {
                self.selectedPlant = "Tomato"
                self.addPlant()
            }) {
                HStack {
                    Image("tomato")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    Text("Tomato")
                        .padding()
                }
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
