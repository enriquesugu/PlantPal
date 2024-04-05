package com.example.plantpalapi.service;

import io.github.cdimascio.dotenv.Dotenv;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

@Service
public class PlantInformationService {

    public JSONObject getPlantInformation(String type, String location) {
        return getChatGPTTips(type, location);
    }


    public JSONObject getChatGPTTips(String type, String location) {
        String url = "https://api.openai.com/v1/chat/completions";
        String model = "gpt-3.5-turbo";

        Dotenv dotenv = null;
        dotenv = Dotenv.configure().load();
        String apiKey = dotenv.get("OPENAI_KEY");

        String prompt = "Give me some plant care tips for " + type + "in " + location +
                ". We are making a plant/garden care application, so don't give me more than 3 sentences worth of information." +
                "Have a friendly tone, and be considerate of the unique type of plant, and the weather considerations of the location, assuming the plant will be outside and exposed to the weather" +
                "Don't give any exact numbers for watering, because we have a function which does that already. Keep your answer to less than 20 words";

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

            output.put("gptTips", jsonResponse.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content"));

            return output;

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
