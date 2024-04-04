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
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Georgia-Bold", size: 36)!]


    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.white, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
                VStack {
                    Text("Main screen")
                    
                    NavigationLink(destination: PlantPage(titleSize: CGFloat(48))) {
                        Text("My Plants")
                            .padding()
                    }
                }
                .navigationBarTitle (Text("PlantPal"), displayMode: .inline)
            }
            .edgesIgnoringSafeArea(.all)
            
        }

    }

}
