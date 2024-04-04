//
//  ContentView.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var titlePage = TitlePage(titleSize: CGFloat(48))
    
    var body: some View {
        let borderSize = CGFloat(-1)
        VStack(spacing: borderSize) {
            titlePage.DisplayTitlePage()
        }
    }

}

#Preview {
    ContentView()
}
