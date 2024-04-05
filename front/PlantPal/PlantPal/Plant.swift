//
//  Plant.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI

struct Plant: Hashable, View {
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(imageName)
        }
    
    let name: String
    let imageName: String
    
    @State private var requiredWater: RequiredWater?
    
    var body: some View {
      
        VStack {
            
            Text("\(name)")
                .bold()
                .font(.title)
            
            
            Spacer()
            
            GeometryReader { geometry in
                        let maxWidth = geometry.size.width - 40
                        let imageSize = CGSize(width: min(maxWidth, 240), height: .infinity)
                        
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: imageSize.width, height: imageSize.height)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 0))
                    }
                    .padding(20)
           
                            
            Spacer()
            
            
            if (requiredWater == nil) {
                ProgressView()
            } else {
                Text("\(requiredWater?.waterRequirementInLitres ?? 0.0)")
            }
            
        }
        .task {
            do {
                requiredWater = try await getRequiredWater(baseWater: "5000", latitude: "-37.9023", longitude: "145.0173")
            } catch WaterError.invalidURL {
                print("invalidURL")
            } catch WaterError.invalidResponse {
                print("invalidResponse")
            } catch WaterError.invalidData {
                print("invalidData")
            } catch {
                print("unexpectedError")
            }
        }
    }
    
    // API call to get required water information
    func getRequiredWater(baseWater: String, latitude: String, longitude: String) async throws -> RequiredWater {
        
        let endpoint = "http://localhost:8080/requiredWater/?baseWater=\(baseWater)&latitude=\(latitude)&longitude=\(longitude)"
        print("yes")
        guard let url = URL(string: endpoint) else {
            throw WaterError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WaterError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            print("didnt catch wooohboo")
            return try decoder.decode(RequiredWater.self, from: data)
        } catch {
            throw WaterError.invalidData
        }
         
//        let endpoint = "http://localhost:8080/requiredWater/?baseWater=\(baseWater)&latitude=\(latitude)&longitude=\(longitude)"
//        guard let url = URL(string: endpoint) else {
//            print("Invalid URL")
//            return
//        }
        
    }
}

struct RequiredWater: Codable {
    let currentTemperature: Double
    let waterRequirementInLitres: Double
    let chatGPTHeadsUp: String
}

enum WaterError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

