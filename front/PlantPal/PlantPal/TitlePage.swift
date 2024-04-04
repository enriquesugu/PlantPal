//
//  Title.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI

struct TitlePage {
    var titleSize: CGFloat
    
    func DisplayTitlePage() -> AnyView {
        return AnyView(VStack(spacing: 4) {
            Section {
                Text("PlantPal")
            }
                .font(.system(size: titleSize))
            Section {
                Text("Plant1")
                Text("Plant2")
            }
        }
            
        )
    }
}
