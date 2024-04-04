package com.example.plantpalapi.api.model;

public class PlantInformation {
    String type;
    double pastTwoDaysRainfall;
    double futureTwoDaysRainfall;
    String analysis;
    String location;

    public PlantInformation(String type, double pastTwoDaysRainfall, double futureTwoDaysRainfall, String analysis, String location) {
        this.type = type;
        this.pastTwoDaysRainfall = pastTwoDaysRainfall;
        this.futureTwoDaysRainfall = futureTwoDaysRainfall;
        this.analysis = analysis;
        this.location = location;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getPastTwoDaysRainfall() {
        return pastTwoDaysRainfall;
    }

    public void setPastTwoDaysRainfall(double pastTwoDaysRainfall) {
        this.pastTwoDaysRainfall = pastTwoDaysRainfall;
    }

    public double getFutureTwoDaysRainfall() {
        return futureTwoDaysRainfall;
    }

    public void setFutureTwoDaysRainfall(double futureTwoDaysRainfall) {
        this.futureTwoDaysRainfall = futureTwoDaysRainfall;
    }

    public String getAnalysis() {
        return analysis;
    }

    public void setAnalysis(String analysis) {
        this.analysis = analysis;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }
}
