class CityWeather {
  String city;
  int temp;
  String desc;
  String icon;
  int humidity;
  double wind;
  int pressure;

  List hourly;
  List daily;

  CityWeather({
    required this.city,
    required this.temp,
    required this.desc,
    required this.icon,
    required this.humidity,
    required this.wind,
    required this.pressure,
    required this.hourly,
    required this.daily,
  });
}