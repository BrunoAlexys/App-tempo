import 'package:app_wheater/models/forecast.dart';
import 'package:app_wheater/services/weather_service.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API
  final _weatherService = WeatherService('b7ccd6900ec20af015dc3beeb6220ace');
  Forecast? _forecast; // Alterado para Forecast em vez de List<Weather>

  // Fetch weather
  _fetchWeather() async {
    try {
      final location = await _weatherService.getCurrentCity();
      final forecast = await _weatherService.getWeeklyWeather('Recife');
      setState(() {
        _forecast = forecast; // Armazena o objeto Forecast
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previsão do Tempo'),
      ),
      body: Column(
        children: _forecast != null
            ? [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Cidade: ${_forecast!.cityName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _forecast!.forecasts.length,
              itemBuilder: (context, index) {
                final item = _forecast!.forecasts[index];
                return ListTile(
                  title: Text(item.dayOfWeek), // Supondo que você tenha um método para obter o dia da semana
                  subtitle: Text(
                    '${item.temperature.toStringAsFixed(1)}°C - ${item.weatherCondition}',
                  ),
                );
              },
            ),
          ),
        ]
            : [Center(child: CircularProgressIndicator())],
      ),
    );
  }
}
