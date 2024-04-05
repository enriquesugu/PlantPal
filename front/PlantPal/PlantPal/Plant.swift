//
//  Plant.swift
//  PlantPal
//
//  Created by Kaiyuan Qian on 4/4/2024.
//

import Foundation
import SwiftUI
import Charts

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
    @State private var isToggleOn = false
    
    let wateringData: [WateringData] = [
        WateringData(date: "Fri", liters: 3.5),

        WateringData(date: "Sat", liters: 2),

        WateringData(date: "Sun", liters: 1.3),

        WateringData(date: "Mon", liters: 3),

        WateringData(date: "Tue", liters: 3.14),

        WateringData(date: "Wed", liters: 2),

        WateringData(date: "Thu", liters: 2.2),
    ]
    
    
    var body: some View {
      
        Text(name)
            .bold()
            .font(.title)
            .padding(.bottom, 15)
        
        if (plantInformation == nil) {
            ProgressView().padding(5)
        } else {
            Text(plantInformation?.gptTips ?? "")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
        }
        
        Divider()
        
        HStack {
            GroupBox(label: Label("Today's Watering", systemImage: "calendar")) {
                if (requiredWater == nil) {
                    ProgressView().padding(10)
                } else {
                    Text(requiredWater?.chatGPTHeadsUp.replacingOccurrences(of: "\"", with: "") ?? "")
                }
                Divider()
                Toggle(isOn: $isToggleOn) {
                    Text("I've watered for the day!")
                }
            }
        }
        .padding(10)
        
        HStack {
            GroupBox(label: Label("Previous 7 Days", systemImage: "sprinkler.and.droplets")) {
                BarChartView(wateringData: wateringData)
            }
        }
        .padding(10)
        
        
            
        
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

struct WateringData: Identifiable {
    let id: String = UUID().uuidString
    
    let date: String
    let liters: Double
    
}

struct BarChartView: View {

    var wateringData: [WateringData]

    var body: some View {
       
        Chart(wateringData) { item in
            BarMark(
                x: .value("Day of week", item.date),
                y: .value("Num litres", item.liters),
                stacking: .standard
            )
            .foregroundStyle(Color.green)
            
        }
        .frame(height: 300)
    }
}

