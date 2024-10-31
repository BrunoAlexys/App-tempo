import 'package:app_wheater/models/weather_data.dart';

class Forecast {
  final String cityName;
  final List<WeatherData> forecasts;

  Forecast({required this.cityName, required this.forecasts});

  factory Forecast.fromJson(Map<String, dynamic> json, String cityName) {
    String city = cityName;
    List<WeatherData> forecastList = [];

    for(var item in json['list']) {
      forecastList.add(WeatherData.fromJson(item, city));
    }

    return Forecast(cityName: city, forecasts: forecastList);
  }
}