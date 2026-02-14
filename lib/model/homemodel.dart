import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_icons/weather_icons.dart';

import '../Apiservices/apiservieses.dart';


class HomePageProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  bool isLoading = false;
  String error = '';
  String cityName = '';
  double temperature = 0;
  String description = '';
  String icon = '';
  int humidity = 0;
  double windSpeed = 0;
  int pressure = 0;
  List<Map<String, dynamic>> hourlyList = [];
  List<Map<String, dynamic>> dailyList = [];

  Future<void> loadWeather() async {
    try {
      isLoading = true;
      notifyListeners();
      final current = await _api.getCurrentWeather();
      cityName = current['name'];
      temperature = current['main']['temp'].toDouble();
      description = current['weather'][0]['description'];
      icon = current['weather'][0]['icon'];
      humidity = current['main']['humidity'];
      windSpeed = current['wind']['speed'].toDouble();
      pressure = current['main']['pressure'];
      final forecastData = await _api.getForecast();
      final List forecastList = forecastData['list'];
      hourlyList.clear();
      dailyList.clear();

      forecastList.take(8).forEach((item) {
        hourlyList.add({
          "time": item['dt_txt'],
          "temp": item['main']['temp'],
          "icon": item['weather'][0]['icon'],
        });
      });

      forecastList.forEach((item) {
        if (item['dt_txt'].toString().contains("12:00:00")) {
          dailyList.add({
            "date": item['dt_txt'],
            "temp": item['main']['temp'],
            "icon": item['weather'][0]['icon'],
          });
        }
      });

      error = '';
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Color> getBackgroundColors() {
    if (description.toLowerCase().contains("clear")) {
      return [Colors.orange, Colors.deepOrangeAccent];
    }
    else if (description.toLowerCase().contains("cloud")) {
      return [Colors.blueGrey, Colors.grey];
    }
    else if (description.toLowerCase().contains("rain")) {
      return [Colors.indigo, Colors.blueGrey];
    }
    else {
      return [Colors.blueAccent, Colors.lightBlue];
    }
  }
  IconData getWeatherIconFromCode(String code) {
    print('line 83');
    print(code);
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




}
