package com.example.plantpalapi.service;
import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
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

            output.put("chatGPTHeadsUp", getChatGPTHeadsUp(baseWater, baseWater/1000 + averageET/1000 - totalPrecip, yesterdaysPrecip, todaysPrecip, tomorrowsPrecip, yesterdaysTemp, todaysTemp, tomorrowsTemp));
            
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

    private String getChatGPTHeadsUp(double baseWater, double actualWater, double yesterdaysPrecip, double todaysPrecip, double tomorrowsPrecip, double yesterdaysTemp, double todaysTemp, double tomorrowsTemp) {
        String url = "https://api.openai.com/v1/chat/completions";
        String model = "gpt-3.5-turbo";

        Dotenv dotenv = null;
        dotenv = Dotenv.configure().load();
        String apiKey = dotenv.get("OPENAI_KEY");

        String prompt = "We are making a plant watering application. Normally, we water this plant " + baseWater/1000 + "liters of water per square meter of plant. " +
                "However, due to weather conditions such as yesterdays temperature and precipitation, todays temperature and precipitation and tomorrows temperature and precipitation, we are only going to suggest watering it " + actualWater +
                "liters. Please provide me a friendly sentence that explains to the user why we are modifying their watering requirements." +
                "I.e 'It's been real hot! You should really water this baby some more!" +
                "Please mention the weather conditions you see as relevant." +
                "Yesterdays precip: " + yesterdaysPrecip +
                "Todays precip: " + todaysPrecip +
                "Tomorrows precip: " + tomorrowsPrecip +
                "Yesterdays temp: " + yesterdaysTemp +
                "Todays temp: " + todaysTemp +
                "Tomorrows temp: " + tomorrowsTemp +
                "Be friendly and unique! Keep your response to one sentence. Use an emoji. Keep in mind we are in Australia when giving your temperature analysis, 25 isn't hot hot like the rest of the world. Make sure to include the number of liters to water with with 2 decimal places";
        try {
            URL obj = new URL(url);
            HttpURLConnection connection = (HttpURLConnection) obj.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + apiKey);
            connection.setRequestProperty("Content-Type", "application/json");

            // The request body
            String body = "{\"model\": \"" + model + "\", \"messages\": [{\"role\": \"user\", \"content\": \"" + prompt + "\"}]}";
            connection.setDoOutput(true);
            OutputStreamWriter writer = new OutputStreamWriter(connection.getOutputStream());
            writer.write(body);
            writer.flush();
            writer.close();

            // Response from ChatGPT
            BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String line;

            StringBuffer response = new StringBuffer();

            while ((line = br.readLine()) != null) {
                response.append(line);
            }
            br.close();

            JSONObject output = new JSONObject();
            JSONObject jsonResponse = new JSONObject(response.toString());
            System.out.println(jsonResponse.toString());

            return jsonResponse.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content");

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
