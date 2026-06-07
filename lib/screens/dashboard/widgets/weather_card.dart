import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/weather_model.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/src/localization/app_localizations.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  Weather? currentWeather;
  String? currentDateTime;
  bool? willRain;
  _fetchWeather() async {
    if (weatherController.currentWeather.value != null) {
      setState(() {
        currentWeather = weatherController.currentWeather.value;
      });
    } else {
      Weather? weather = await weatherController.getCurrentWeather();
      if (weather != null) {
        setState(() {
          currentWeather = weather;
        });
      }
    }
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM', 'ne_NP').format(now);
    setState(() {
      currentDateTime = formattedDate;
    });
  }

  _fetchForecast() async {
    try {
      List<bool> data = await weatherController.getWeatherForecast();
      bool allTrue = data.any((element) => element == true);
      setState(() {
        willRain = allTrue;
      });
    } catch (e) {
      print(e);
    }
  }

  //Weather Animation
  String getWeatherAnimation({String? mainCondition, String? descCondition}) {
    if (mainCondition == null) return 'assets/animations/weather/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'thunderstrom':
        return 'assets/animations/weather/cloud_thunder.json';
      case 'drizzle':
        return 'assets/animations/weather/rain_sun.json';
      case 'rain':
        return 'assets/animations/weather/rain_thunder.json';
      case 'snow':
        return 'assets/animations/weather/sun_snow.json';
      case 'clear':
        return 'assets/animations/weather/sunny.json';
      case 'clouds':
        return 'assets/animations/weather/cloud.json';
      default:
        return 'assets/animations/weather/sunny.json';
    }
  }

  @override
  void initState() {
    _fetchWeather();
    _fetchForecast();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return currentWeather != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${currentWeather?.cityName ?? 'Loading City...'},$currentDateTime',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(10),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                convertToNepaliNumber(currentWeather!
                                    .temperature
                                    .round()
                                    .toString()),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 48,
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                '°${AppLocalizations.of(context)!.c}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(8),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.water_drop,
                                size: 16,
                                color: kPrimaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${AppLocalizations.of(context)!.humidity} ${convertToNepaliNumber(currentWeather!.humidity.round().toString())}%',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Lottie.asset(
                            getWeatherAnimation(
                              mainCondition: currentWeather?.mainCondition,
                              descCondition: currentWeather?.mainCondition,
                            ),
                            repeat: true,
                            height: getProportionateScreenHeight(80),
                          ),
                          SizedBox(
                            height: getProportionateScreenHeight(3),
                          ),
                          Text(
                            currentWeather?.mainCondition ?? '',
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(
                    color: Colors.grey[200],
                    thickness: 1,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: willRain != null && willRain == false
                          ? Colors.green[50]
                          : Colors.orange[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: willRain != null && willRain == false
                            ? Colors.green[200]!
                            : Colors.orange[200]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          willRain != null && willRain == false
                              ? Icons.check_circle
                              : Icons.info,
                          size: 18,
                          color: willRain != null && willRain == false
                              ? Colors.green[700]
                              : Colors.orange[700],
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            willRain != null && willRain == false
                                ? 'कीटनाशक प्रयोग गर्न आजको दिन राम्रो छ।'
                                : 'कीटनाशक प्रयोग गर्न आजको दिन राम्रो छैन।',
                            style: TextStyle(
                              color: willRain != null && willRain == false
                                  ? Colors.green[900]
                                  : Colors.orange[900],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
