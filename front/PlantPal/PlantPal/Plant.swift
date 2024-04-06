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
    let squareMeters: Double
    let baseWater: Double
    
    
    @State private var requiredWater: RequiredWater?
    @State private var plantInformation: PlantInformation?
    @State private var isToggleOn = false
    @State private var waterSavedThisPlant = 0.0
    
    @EnvironmentObject var locationManager: LocationManager
    
    let wateringData: [WateringData] = [
        WateringData(date: "Fri", liters: 3.5, type: .naturalRain),
        WateringData(date: "Fri", liters: 1.2, type: .yourWater),
        WateringData(date: "Fri", liters: 0.3, type: .tempAndET),
        
        WateringData(date: "Sat", liters: 1.9, type: .naturalRain),
        WateringData(date: "Sat", liters: 1.6, type: .yourWater),
        WateringData(date: "Sat", liters: 1.5, type: .tempAndET),

        WateringData(date: "Sun", liters: 3.1, type: .naturalRain),
        WateringData(date: "Sun", liters: 1.0, type: .yourWater),
        WateringData(date: "Sun", liters: 0.9, type: .tempAndET),

        WateringData(date: "Mon", liters: 2.5, type: .naturalRain),
        WateringData(date: "Mon", liters: 2.0, type: .yourWater),
        WateringData(date: "Mon", liters: 0.5, type: .tempAndET),

        WateringData(date: "Tue", liters: 1.5, type: .naturalRain),
        WateringData(date: "Tue", liters: 3.2, type: .yourWater),
        WateringData(date: "Tue", liters: 0.3, type: .tempAndET),

        WateringData(date: "Wed", liters: 0.1, type: .naturalRain),
        WateringData(date: "Wed", liters: 4.1, type: .yourWater),
        WateringData(date: "Wed", liters: 0.8, type: .tempAndET),

        WateringData(date: "Thu", liters: 0.8, type: .naturalRain),
        WateringData(date: "Thu", liters: 3.5, type: .yourWater),
        WateringData(date: "Thu", liters: 0.7, type: .tempAndET)

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
                .onChange(of: isToggleOn) { newValue in
                    calculateWaterSaved(newValue)
                }
            }
        }
        .padding(10)
        
        HStack {
            GroupBox(label: Label("Previous 7 Days", systemImage: "sprinkler.and.droplets")) {
                BarChartView(wateringData: wateringData)
                HStack(spacing: 6) {
                    ForEach(WateringType.allCases, id: \.self) { type in
                        Circle()
                            .fill(type.color)
                            .frame(width: 8, height: 8)
                        Text(type.rawValue)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(type.color)
                    }
                }
            }
        }
        .padding(10)
        
        
            
        
        .task {
            do {
                if let coordinates = locationManager.userLocation {
                    requiredWater = try await getRequiredWater(baseWater: String(baseWater * squareMeters), latitude: "\(coordinates.latitude)", longitude: "\(coordinates.longitude)")
                    plantInformation = try await getPlantInformation(type: name, location: "Melbourne")
                    print(coordinates.latitude)
                    print(coordinates.longitude)
                } else {
                    requiredWater = try await getRequiredWater(baseWater: String(baseWater * squareMeters), latitude: "-37.9023", longitude: "145.0173")
                    plantInformation = try await getPlantInformation(type: name, location: "Melbourne")
                }
                
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
    
    func calculateWaterSaved(_ newValue: Bool) {
        if newValue {
            waterSavedThisPlant += baseWater/1000 - (requiredWater?.waterRequirementInLitres ?? baseWater)
            TotalWaterSaved.shared.updateTotalWaterSaved(amount: waterSavedThisPlant)
            print(TotalWaterSaved.shared.totalWaterSaved)
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

enum WateringType: String, CaseIterable {
    case naturalRain = "Natural Rain"
    case yourWater = "Your Water"
    case tempAndET = "Temperature and ET"

    var color: Color {
        switch self {
        case .naturalRain:
            return .green
        case .yourWater:
            return .yellow
        case .tempAndET:
            return .pink
        }
    }
}

struct WateringData: Identifiable {
    let id: String = UUID().uuidString
    
    let date: String
    let liters: Double
    let type: WateringType
    
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
            .foregroundStyle(item.type.color)
            
        }
        .frame(height: 300)
        .chartLegend(.visible)
//        .chartLegend(position: .bottom, alignment: .leading, spacing: 24, content: {
//            HStack(spacing: 6) {
//                ForEach(WateringType.allCases, id: \.self) { type in
//                    Circle()
//                        .fill(type.color)
//                        .frame(width: 8, height: 8)
//                    Text(type.rawValue)
//                        .font(.system(size: 11, weight: .medium))
//                        .foregroundColor(type.color)
//                }
//            }
//        })
    }
}

