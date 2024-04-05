//
//  AddPlantItem.swift
//  PlantPal
//
//  Created by Henry Fielding on 6/4/2024.
//

import Foundation
import SwiftUI

struct AddPlantItem: View {

    @Binding var plantName: String

    var body: some View {
        Text(plantName)
    }
}
