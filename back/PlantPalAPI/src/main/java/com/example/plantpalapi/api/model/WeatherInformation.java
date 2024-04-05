package com.example.plantpalapi.api.model;

public class WeatherInformation {
    double waterRequirement;

    public WeatherInformation(double waterRequirement) {
        this.waterRequirement = waterRequirement;
    }

    public double getWaterRequirement() {
        return waterRequirement;
    }

    public void setWaterRequirement(double waterRequirement) {
        this.waterRequirement = waterRequirement;
    }
}
