//
//  AddPlantItem.swift
//  PlantPal
//
//  Created by Henry Fielding on 6/4/2024.
//

import Foundation
import SwiftUI

struct AddPlantItem: View {

    @State var plantName: String
    @Binding var selectedPlant: String?

    var body: some View {
        Button(action: {
            selectedPlant = plantName
        }) {
            HStack {
                Text(plantName)
                Spacer()
                Image(plantName.lowercased())
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                        .overlay(Circle().stroke(Color.green, lineWidth: 2))
            }
        }
        .tint(.green)
    }
}
