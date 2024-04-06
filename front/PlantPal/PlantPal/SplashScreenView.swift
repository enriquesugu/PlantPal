//
//  SplashScreenView.swift
//  PlantPal
//
//  Created by Enrique Sugunananthan on 5/4/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {

        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image(colorScheme == .dark ? "PlantPalDark" : "PlantPal")
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

