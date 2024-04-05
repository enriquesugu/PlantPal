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
    @State private var plantInformation: PlantInformation?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.clear, .green]), startPoint: .init(x: 0.5, y: 0.8), endPoint: .bottom)
            VStack {
                Image("\(imageName)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                Text("\(name)")
                    .bold()
                //Text("You need \(requiredWater?.waterRequirementInLitres) litres of water" ?? "Placeholder")
                
                if (requiredWater == nil) {
                    ProgressView()
                } else {
                    Text("Today you will need \(requiredWater?.waterRequirementInLitres ?? 0.0) litres of water.")
                    Spacer()
                        .frame(height: 50)
                    Text("\(requiredWater?.chatGPTHeadsUp ?? "")")
                    Spacer()
                        .frame(height: 50)
                    Text("\(plantInformation?.gptTips ?? "")")
                }
                
            }
            
            
        }
        .edgesIgnoringSafeArea(.all)
        .task {
            do {
                requiredWater = try await getRequiredWater(baseWater: "5000", latitude: "-37.9023", longitude: "145.0173")
                plantInformation = try await getPlantInformation(type: name, location: "Melbourne")
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
        
    }
    
    // API call to get plant information
    func getPlantInformation(type: String, location: String) async throws -> PlantInformation {
        let endpoint = "http://localhost:8080/plantInformation/?type=\(type)&location=\(location)"
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
            return try decoder.decode(PlantInformation.self, from: data)
        } catch {
            throw WaterError.invalidData
        }
    }
}

struct RequiredWater: Codable {
    let currentTemperature: Double
    let waterRequirementInLitres: Double
    let chatGPTHeadsUp: String
}

struct PlantInformation: Codable {
    let gptTips: String
}

enum WaterError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
