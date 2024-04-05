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
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Avenir Book", size: 48)!]
    }
    
    @State private var plants: [Plant] = []
    @State private var showingAddPlantPage = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.clear, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
                VStack {
                    Text("Main screen")
                    
                    NavigationLink(destination: PlantPage(plants: plants)) {
                        Text("My Plants")
                    }
                    
                    Button(action: {
                        showingAddPlantPage = true
                    }) {
                        Text("Add Plant")
                    }
                }
                .navigationBarTitle (Text("PlantPal"), displayMode: .inline)
                
                /*.navigationDestination(for: String.self) { value in
                    PlantPage()
                }*/
            }
        }
        .sheet(isPresented: $showingAddPlantPage) {
            AddPlantPage(plants: $plants)
        }
    }
}
