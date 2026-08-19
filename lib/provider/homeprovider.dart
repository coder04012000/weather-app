import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:weather_icons/weather_icons.dart';

import '../Apiservices/apiservieses.dart';
import '../model/homemodel.dart';

class HomePageProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  bool isLoading = false;
  String error = '';

  List<CityWeather> cities = [];
  int currentIndex = 0;

  Future<void> loadCurrentWeather() async {
    try {
      isLoading = true;
      notifyListeners();

      final current = await _api.getCurrentWeather();
      final forecast = await _api.getForecast();

      final cityWeather = _buildCityWeather(current, forecast);

      if (cities.isEmpty) {
        cities.add(cityWeather);
      } else {
        cities[0] = cityWeather;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCity(String cityName) async {
    try {
      final current = await _api.getWeatherByCity(cityName);
      final forecast = await _api.getForecastByCity(cityName);

      final cityWeather = _buildCityWeather(current, forecast);


      if (!cities.any((c) => c.city == cityWeather.city)) {
        cities.add(cityWeather);
        await saveCities();
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveCities() async {
    final box = Hive.box('weatherBox');

    List<String> cityNames = cities.map((c) => c.city).toList();

    box.put('cities', cityNames);
  }

  Future<void> loadSavedCities() async {
    final box = Hive.box('weatherBox');

    List? cityNames = box.get('cities');

    if (cityNames != null) {
      for (String city in cityNames) {
        if (!cities.any((c) => c.city == city)) {
          await addCity(city);
        }
      }
    }
  }

  List<Color> getBackgroundColors(String desc) {
    if (desc.toLowerCase().contains("clear")) {
      return [Colors.orange, Colors.deepOrangeAccent];
    } else if (desc.toLowerCase().contains("cloud")) {
      return [Colors.blueGrey, Colors.grey];
    } else if (desc.toLowerCase().contains("rain")) {
      return [Colors.indigo, Colors.blueGrey];
    } else if (desc.toLowerCase().contains("snow")) {
      return [Colors.lightBlueAccent, Colors.white70];
    } else {
      return [Colors.blueAccent, Colors.lightBlue];
    }
  }

  IconData getWeatherIconFromCode(String? code) {
    if (code == null || code.isEmpty) {
      return WeatherIcons.day_cloudy;
    }

    if (code.startsWith("01")) {
      return WeatherIcons.day_sunny;
    } else if (code.startsWith("02")) {
      return WeatherIcons.day_cloudy;
    } else if (code.startsWith("03") || code.startsWith("04")) {
      return WeatherIcons.cloud;
    } else if (code.startsWith("09") || code.startsWith("10")) {
      return WeatherIcons.rain;
    } else if (code.startsWith("11")) {
      return WeatherIcons.thunderstorm;
    } else if (code.startsWith("13")) {
      return WeatherIcons.snow;
    } else if (code.startsWith("50")) {
      return WeatherIcons.fog;
    } else {
      return WeatherIcons.day_cloudy;
    }
  }

  CityWeather _buildCityWeather(current, forecastData) {
    List<Map<String, dynamic>> hourly = [];
    List<Map<String, dynamic>> daily = [];

    final List forecastList = forecastData['list'];

    forecastList.take(8).forEach((item) {
      hourly.add({
        "time": item['dt_txt'],
        "temp": item['main']['temp'],
        "icon": item['weather'][0]['icon'],
      });
    });

    forecastList.forEach((item) {
      if (item['dt_txt'].toString().contains("12:00:00")) {
        daily.add({
          "date": item['dt_txt'],
          "temp": item['main']['temp'],
          "icon": item['weather'][0]['icon'],
        });
      }
    });

    return CityWeather(
      city: current['name'],
      temp: current['main']['temp'].round(),
      desc: current['weather'][0]['description'],
      icon: current['weather'][0]['icon'],
      humidity: current['main']['humidity'],
      wind: current['wind']['speed'].toDouble(),
      pressure: current['main']['pressure'],
      hourly: hourly,
      daily: daily,
    );
  }
}
