package com.example.plantpalapi.service;

import org.springframework.stereotype.Service;

@Service
public class PlantInformationService {

    public String getPlantInformation(String type, String location) {
        return "Chatgpt says some stuff about " + type;
    }
}
