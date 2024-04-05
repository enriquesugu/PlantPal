package com.example.plantpalapi.service;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.IOException;
import org.json.JSONObject;

@Service
public class WeatherInformationService {
    public JSONObject getRequiredWater(double baseWater, double longitude, double latitude) {
        return calculateAllRequirements(baseWater, longitude, latitude);
    }

    private JSONObject calculateAllRequirements(double baseWater, double longitude, double latitude) {
        System.out.println("Extracting weather data from open-meteo...");

        try {
            String url = "https://api.open-meteo.com/v1/forecast?latitude=" +
                    latitude +
                    "&longitude=" +
                    longitude +
                    "&current=temperature_2m,rain&daily=temperature_2m_max,rain_sum&timezone=Australia%2FSydney&past_days=1&forecast_days=2";
            URL obj = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) obj.openConnection();
            connection.setRequestMethod("GET");

            BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String inputLine;
            StringBuilder response = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            System.out.println(response.toString());

            // Et calcs
            JSONObject output = new JSONObject();
            JSONObject jsonResponse = new JSONObject(response.toString());

            output.put("currentTemperature", jsonResponse.getJSONObject("current").getDouble("temperature_2m"));

            double yesterdaysTemp = jsonResponse.getJSONObject("daily").getJSONArray("temperature_2m_max").getDouble(0);
            double todaysTemp = jsonResponse.getJSONObject("daily").getJSONArray("temperature_2m_max").getDouble(2);
            double tomorrowsTemp = jsonResponse.getJSONObject("daily").getJSONArray("temperature_2m_max").getDouble(2);

            double averageET = calculateAverageET(calculateET(1.2, yesterdaysTemp),
                    calculateET(1.2, todaysTemp),
                    calculateET(1.2, tomorrowsTemp));

            double yesterdaysPrecip = jsonResponse.getJSONObject("daily").getJSONArray("rain_sum").getDouble(0);
            double todaysPrecip = jsonResponse.getJSONObject("daily").getJSONArray("rain_sum").getDouble(1);
            double tomorrowsPrecip = jsonResponse.getJSONObject("daily").getJSONArray("rain_sum").getDouble(2);
            double totalPrecip = yesterdaysPrecip + todaysPrecip + tomorrowsPrecip;


            // according to rainharvesting.com.au Roughly speaking, 1 millimetre of rain over 1 square metre of roof equals 1 litre of water.
            output.put("waterRequirementInLitres", baseWater/1000 + averageET/1000 - totalPrecip);
            
            return output;

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    private double calculateET(double evapConstant, double temperature) {
        return evapConstant * temperature;
    }

    private double calculateAverageET(double yesterdaysET, double todaysET, double tomorrowsET) {
        return (yesterdaysET + todaysET + tomorrowsET) / 3;
    }
}