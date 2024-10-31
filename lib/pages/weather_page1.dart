import 'package:app_wheater/components/InputSearch.dart';
import 'package:app_wheater/models/forecast.dart';
import 'package:app_wheater/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherPage1 extends StatefulWidget {
  const WeatherPage1({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage1> {
  final _weatherService = WeatherService('b7ccd6900ec20af015dc3beeb6220ace');
  Forecast? _forecast;
  final TextEditingController _cityController = TextEditingController();

  _initializeCity() async {
    try {
      final location = await _weatherService.getCurrentCity();
      await _fetchWeather(location);
    } catch (e) {
      print('Erro ao obeter a cidade atual: $e');
    }
  }

  Future<void> _fetchWeather(String cityName) async {
    try {
      final forecast = await _weatherService.getWeeklyWeather(cityName);
      setState(() {
        _forecast = forecast;
        _cityController.text = cityName;
      });
    } catch (e) {
      print('Erro ao buscar a previsão do tempo: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 55.0),
            child: Container(
              child: InputSearch(
                controller: _cityController,
                onCitySelected: _fetchWeather,
              ),
            ),
          ),
          Container(
            child: _forecast != null && _forecast!.forecasts.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        DateFormat('EEEE')
                            .format(DateTime.now()), // Dia da semana
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${_forecast!.forecasts[0].temperature.toStringAsFixed(1)} °C',
                        // Temperatura atual
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                : CircularProgressIndicator(), // Exibe um indicador de progresso enquanto aguarda os dados
          ),
          Container(),
        ],
      ),
    );
  }
}
