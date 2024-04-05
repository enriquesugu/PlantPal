//
//  ContentView.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 36, weight: .bold)]
    }
    
    @State private var plants: [Plant] = []
    @State private var showingAddPlantPage = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Text("Welcome back, Henry!")
                
                Spacer()
                
                PlantPage(plants: plants)
                
                Spacer()

                HStack {
                    NavigationLink(destination: PlantPage(plants: plants)) {
                        Text("TBC BUTTON")
                    }
                    .foregroundColor(Color(hex: 0xdad7cd))
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0x588157)))
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddPlantPage = true
                    }) {
                        Text("Add Plant")
                    }
                    .foregroundColor(Color(hex: 0xdad7cd))
                    .padding(20)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0x588157)))
                }
                .padding(48)
                
    
            }
            .navigationBarTitle (Text("PlantPal"), displayMode: .inline)
            .padding(.top, 0)
        }
        .sheet(isPresented: $showingAddPlantPage) {
            AddPlantPage(plants: $plants)
        }
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double((hex) & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
