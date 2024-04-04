package com.example.plantpalapi.api.controller;

import com.example.plantpalapi.service.PlantInformationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlantInformationController {

    private PlantInformationService plantService;

    @Autowired
    public PlantInformationController(PlantInformationService plantService) {
        this.plantService = plantService;
    }

    @GetMapping("plantInformation/")
    public String getPlantInformation(@RequestParam String type, @RequestParam String location) {
        return plantService.getPlantInformation(type, location);
    }
}
