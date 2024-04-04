package com.example.plantpalapi.api.controller;

import com.example.plantpalapi.service.WeatherInformationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class WeatherInformationController {

    private WeatherInformationService weatherInformationService;

    @Autowired
    public WeatherInformationController(WeatherInformationService weatherInformationService) {
        this.weatherInformationService = weatherInformationService;
    }

    @GetMapping("requiredWater/")
    public String getWeatherInformation(@RequestParam double baseWater, @RequestParam double longitude, @RequestParam double latitude) {
        return weatherInformationService.getRequiredWater(baseWater, longitude, latitude).toString();
    }
}