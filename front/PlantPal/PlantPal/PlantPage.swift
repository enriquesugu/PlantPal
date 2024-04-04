//
//  Title.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI

struct PlantPage: View {
    var titleSize: CGFloat
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    Text("PlantPal")
                }
                    .font(.system(size: titleSize))
                Section {
                    Text("Plant1")
                    Text("Plant2")
                }
            }
            
        }
    }
}
