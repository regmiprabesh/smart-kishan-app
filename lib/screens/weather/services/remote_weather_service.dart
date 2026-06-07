import 'package:http/http.dart' as http;
import 'package:smart_kishan/models/soildata.dart';

class RemoteWeatherService {
  static const currentWeatherUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const forecastWeatherUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  static const apiKey = 'c4b7fbf4de4ceaa9f8cef84046addfb5';

  Future<dynamic> getWeather(Coordinates coordinates) async {
    final response = await http.get(Uri.parse(
        '$currentWeatherUrl?lat=${coordinates.lat}&lon=${coordinates.lng}&appid=$apiKey&units=metric'));
    return response;
  }

  Future<dynamic> getForecast() async {
    double lat = 27.667176;
    double lng = 85.350614;
    final response = await http.get(Uri.parse(
        '$forecastWeatherUrl?lat=$lat&lon=$lng&appid=$apiKey&units=metric'));
    return response;
  }
}
