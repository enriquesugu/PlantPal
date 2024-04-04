package com.example.plantpalapi.service;

import org.springframework.stereotype.Service;

@Service
public class PlantService {

    public String getPlantInformation(String type, String location) {
        return "Hello" + type;
    }
}
