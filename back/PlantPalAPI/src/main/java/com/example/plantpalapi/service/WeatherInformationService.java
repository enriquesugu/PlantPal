package com.example.plantpalapi.service;
import org.springframework.stereotype.Service;
@Service
public class WeatherInformationService {
    public String getRequiredWater(String type, String location) {
        return "weather api says to do XXml for " + type + " in " + location;
    }
}
