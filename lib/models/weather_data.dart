class WeatherData {
  final String cityName;
  final double temperature;
  final String dayOfWeek;
  final String weatherCondition;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.dayOfWeek,
    required this.weatherCondition,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, String cityName) {
    // Dados da previsão
    var mainData = json['main'];
    var weatherData = json['weather'][0];

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);

    return WeatherData(
      cityName: cityName,
      temperature: mainData['temp'].toDouble(),
      dayOfWeek: _getDayOfWeek(dateTime),
      weatherCondition: weatherData['description'],
    );
  }

  static String _getDayOfWeek(DateTime dateTime) {
    List<String> days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
    return days[dateTime.weekday];
  }
}