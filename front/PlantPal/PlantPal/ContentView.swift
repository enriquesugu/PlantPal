//
//  ContentView.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import SwiftUI
import SwiftData
import CoreLocation

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [
            .font : UIFont.systemFont(ofSize: 36, weight: .bold)]
    }
    
    @State private var plants: [Plant] = []
    @State private var showingAddPlantPage = false
    @ObservedObject var totalWaterSaved = TotalWaterSaved.shared
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        NavigationStack {
            HStack {
                Image("PlantPalSmall")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 50)
                    .padding(.leading, 10)
                //Spacer()
            }
            .padding(.horizontal, 10)
            
            VStack {
                Text("Welcome back!")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                Text("Since joining PlantPal you've saved over")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                Text(String(format: "%.2f", TotalWaterSaved.shared.totalWaterSaved) + "L")
                    .foregroundColor(Color.green)
                    .font(.title)
                    .bold()
                Text("of water. Keep it up!")
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            
            Divider()
            
            GroupBox(label: Label("Your garden", systemImage: "leaf")) {
                Divider()
                PlantPage(plants: $plants)
            }.padding(.horizontal, 10)
            
            //Divider()
            
            Button("Add a new plant to your garden", systemImage: "plus",action: {
                showingAddPlantPage = true
            })
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .sheet(isPresented: $showingAddPlantPage) {
            AddPlantPage(plants: $plants)
        }
        .environmentObject(locationManager)
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
