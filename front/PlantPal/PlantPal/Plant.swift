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
            
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 48)
                    .edgesIgnoringSafeArea(.top)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: 0x588157))
                        .frame(width: 200, height: 40)
                    
                    Text(name)
                        .bold()
                        .font(.title)
                        .foregroundColor(Color(hex: 0xdad7cd))
                }
            }
            Divider()
            
            
            if (requiredWater == nil) {
                ProgressView()
            } else {
//                VStack {
//                    VStack {
////                        Image(systemName: "oilcan")
////                                    .font(.system(size: 38))
////                                    .foregroundColor(Color(hex: 0xdad7cd))
////                                    .padding(10)
//                        
//                        Text("You need to water your \(name) with " + String(format: "%.2f", requiredWater?.waterRequirementInLitres ?? 0.0) + "L today!")
//                            .foregroundColor(Color(hex: 0xdad7cd))
//                            .padding(20)
//                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0x344e41)))
//                    }
//                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0x344e41)))
//                    .padding(10)
//                
//                    HStack {
//                        VStack {
//                            Text("Hot tip!")
//                                .foregroundColor(Color(hex: 0xdad7cd))
//                                .fontWeight(.bold)
//                                .padding(10)
//                            Text("chatgpt here")
//                                .foregroundColor(Color(hex: 0xdad7cd))
//                                .padding(10)
//                        }
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0x588157)))
//                        .padding(10)
//                    
//                        
//                        HStack {
//                            Image(systemName: "trash.fill")
//                                .font(.system(size: 38))
//                                .foregroundColor(Color(hex: 0xdad7cd))
//                                .padding(20)
//                                .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0xe63946)))
//                        }
//                    }
//                }
//                .padding(10)
                VStack {
                    HStack {
                        Text("Water Requirements")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x344e41))
                        Spacer()
                    }
                    
                    Text("Hey there plant parent! With the recent sunny days and warm temperatures, your leafy friend could use a little extra love in the form of 5.1 liters of water per square meter. Let's keep those roots happy and hydrated! 🌿💦")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                }
                .padding(.horizontal, 10)
                
                Divider()
                
                VStack {
                    HStack {
                        Text("Our Top Tip")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: 0x344e41))
                        Spacer()
                    }
                    
                    Text("When caring for your tomatoes in Melbourne, be sure to give them plenty of sunlight as they thrive in warm weather. Water your plants regularly, making sure not to overwater as they can be sensitive to too much moisture. Keep an eye out for pests like aphids and caterpillars, and remove them promptly to prevent damage to your plants. Happy gardening!")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                }
                .padding(.horizontal, 10)
                
                Divider()
                
                
            }
            
            Spacer()
//            
//            
//            Image(imageName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 180)
           
            
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

