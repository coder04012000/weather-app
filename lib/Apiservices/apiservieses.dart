
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String apiKey = "178488549ffa0d3ae044d72879bbaa7f";

  Future<Map<String, dynamic>> getCurrentWeather() async {
    const url =
        "https://api.openweathermap.org/data/2.5/weather?lat=26.2942&lon=81.8622&units=metric&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load current weather");
    }
  }

  Future<Map<String, dynamic>> getForecast() async {
    const url =
        "https://api.openweathermap.org/data/2.5/forecast?lat=26.2942&lon=81.8622&units=metric&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load forecast");
    }
  }
}
