package com.example.plantpalapi.service;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.net.URLEncoder;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpClient;
import java.io.IOException;

import io.github.cdimascio.dotenv.Dotenv;
import io.github.cdimascio.dotenv.DotenvException;

@Service
public class WeatherInformationService {
    public String getRequiredWater(double baseWater, double longitude, double latitude) {
        return getLiveWeather(longitude, latitude);
    }

    private String getLiveWeather(double longitude, double latitude) {
        System.out.println("Extracting weather data from open-meteo...");

        try {
            String url = "https://api.open-meteo.com/v1/forecast?latitude=" +latitude+ "&longitude=" + longitude + "&hourly=temperature_2m,rain&daily=rain_sum&timezone=Australia%2FSydney";
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
            return response.toString();

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
}
