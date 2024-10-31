import 'dart:convert';

import 'package:app_wheater/models/forecast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String BASE_URL = 'http://api.openweathermap.org/data/2.5/forecast'; // Alterado para "forecast"
  final String apiKey;

  WeatherService(this.apiKey);

  /// Busca a previsão semanal usando coordenadas e nome da cidade.
  Future<Forecast> getWeeklyWeather(String cityName) async {
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));
    print('URL: ${response.request}');
    if (response.statusCode == 200) {
      print(response.body);
      return Forecast.fromJson(jsonDecode(response.body), cityName);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  /// Obtém a cidade atual usando o Geolocator.
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude, position.longitude,
    );

    print('Lat: ${position.latitude} - Long: ${position.longitude}');
    print('Plac: $placemarks');

    // Nome da cidade com fallback
    String cityName = placemarks.isNotEmpty && placemarks[0].subAdministrativeArea != null
        ? placemarks[0].subAdministrativeArea!
        : 'Cidade não encontrada';

    return cityName;
  }
}
