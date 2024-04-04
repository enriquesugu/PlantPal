package com.example.plantpalapi.api.controller;

import com.example.plantpalapi.api.model.PlantInformation;
import com.example.plantpalapi.service.PlantService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PlantController {

    private PlantService plantService;

    @Autowired
    public PlantController(PlantService plantService) {
        this.plantService = plantService;
    }

    @GetMapping("plantInformation/")
    public String getPlantInformation(@RequestParam String type, @RequestParam String location) {
        return plantService.getPlantInformation(type, location);
    }
}
