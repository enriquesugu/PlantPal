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
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 4, alignment: nil),
        GridItem(.flexible(), spacing: 4, alignment: nil),
        GridItem(.flexible(), spacing: 4, alignment: nil),
    ]
    
    var body: some View {
        VStack {
            Text("Select a Plant to Add:")
                .font(.title)
                .padding()
            LazyVGrid(columns: columns) {
                Button(action: {
                    self.selectedPlant = "Passionfruit"
                    self.addPlant()
                }) {
                    VStack {
                        Image("passionfruit")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text("Passionfruit")
                            .padding()
                    }
                    .background(Color.white)
                    .foregroundColor(.black)
                    
                }
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10)
                .buttonStyle(ScaleButtonStyle())
                
                
                Button(action: {
                    self.selectedPlant = "Strawberry"
                    self.addPlant()
                }) {
                    VStack {
                        Image("strawberry")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                        Text("Strawberry")
                            .padding()
                    }
                    .background(Color.white)
                    .foregroundColor(.black)
                }
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .shadow(color: Color.black.opacity(0.2), radius: 10)
                .buttonStyle(ScaleButtonStyle())
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

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}
