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
    public String getRequiredWater(String type, String location) {
        return getLiveWeather(location);
    }

    private String getLiveWeather(String location) {
        System.out.println("Extracting weather data from Weatherstack...");

        Dotenv dotenv = null;
        dotenv = Dotenv.configure().load();

        String apiKey = dotenv.get("WEATHERSTACK_KEY");
        System.out.println(apiKey);
        String query = "Melbourne";

        try {
            String url = "http://api.weatherstack.com/current?access_key=" + apiKey + "&query=" + URLEncoder.encode(query, "UTF-8");
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
