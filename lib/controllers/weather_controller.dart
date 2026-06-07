import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_kishan/models/soildata.dart';
import 'package:smart_kishan/models/weather_model.dart';
import 'package:smart_kishan/screens/weather/services/remote_weather_service.dart';

class WeatherController extends GetxController {
  static WeatherController instance = Get.find();
  RxBool isWeatherLoading = false.obs;
  Rxn<Weather> currentWeather = Rxn<Weather>();
  RxBool willRainToday = false.obs;
  RxBool willRainTomorrow = false.obs;
  @override
  void onInit() async {
    super.onInit();
    getCurrentWeather();
    getCurrentCity();
  }

  Future<Weather?> getCurrentWeather() async {
    try {
      isWeatherLoading(false);
      var result = await RemoteWeatherService().getWeather(
          Coordinates(lat: 27.650061458918543, lng: 85.32219631281998));
      Weather weather = Weather.fromJson(jsonDecode(result.body));
      currentWeather(weather);
      return currentWeather.value;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<dynamic> getWeatherForecast() async {
    try {
      isWeatherLoading(false);
      var result = await RemoteWeatherService().getForecast();
      willRainToday.value = checkRain(jsonDecode(result.body), DateTime.now());
      willRainTomorrow.value = checkRain(
          jsonDecode(result.body), DateTime.now().add(const Duration(days: 1)));
      return ([willRainToday.value, willRainTomorrow.value]);
    } catch (e) {
      print(e);
    }
    return null;
  }

  bool checkRain(Map<String, dynamic> weatherData, DateTime date) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final dateString = dateFormat.format(date);
    for (var item in weatherData['list']) {
      if (item['dt_txt'].startsWith(dateString) &&
          item['weather'][0]['main'] == 'Rain') {
        return true;
      }
    }
    return false;
  }

  Future<dynamic> getCurrentCity() async {
    double lat = 27.650061458918543;
    double lng = 85.32219631281998;
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        lat,
        lng,
      );
      String? city = placemarks[0].locality;
      print(city);
      print(placemarks);
    } catch (e) {
      print(e);
    }
  }

  void reset() {
    isWeatherLoading(false);
    currentWeather(null);
    willRainToday(false);
    willRainTomorrow(false);
  }
}
