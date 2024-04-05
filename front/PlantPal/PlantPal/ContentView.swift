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
            HStack {
                Text("Welcome back, Henry!")
                    .bold()
                    .font(.title)
                Spacer()
            }
            .padding(.horizontal, 10)
            
            VStack {
                Text("Since joining PlantPal you've saved over")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                Text("120.46L")
                    .foregroundColor(Color.green)
                    .font(.title)
                    .bold()
                Text("of water. Keep it up!")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            
            //Divider()
            
            HStack {
                Text("Your garden")
                    .bold()
                    .font(.title2)
                Spacer()
            }
            .padding(.horizontal, 10)
            Divider()
            
            PlantPage(plants: $plants)
            
            Divider()
            
            Button("Add a new plant to your garden", systemImage: "plus",action: {
                showingAddPlantPage = true
            })
            .buttonStyle(.borderedProminent)
            .tint(.green)
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
