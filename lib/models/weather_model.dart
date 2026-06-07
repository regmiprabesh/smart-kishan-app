class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String descCondition;
  final double humidity;
  Weather(
      {required this.cityName,
      required this.temperature,
      required this.mainCondition,
      required this.descCondition,
      required this.humidity});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      descCondition: json['weather'][0]['description'],
      humidity: json['main']['humidity'].toDouble(),
    );
  }
}
