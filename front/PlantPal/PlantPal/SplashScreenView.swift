//
//  SplashScreenView.swift
//  PlantPal
//
//  Created by Enrique Sugunananthan on 5/4/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {

        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("PlantPal")
                        .font(.system(size : 80))
                }
            }
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }

        }
    }
}

