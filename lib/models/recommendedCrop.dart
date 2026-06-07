import 'dart:convert';

class RecommendedCropData {
  final String latitude;
  final String longitude;
  final List<RecommendedVegetable> recommendedVegetable;
  final List<RecommendedFruit> recommendedFruits;
  final LocationProperties locationProperties;
  final List<CropProperty> cropProperties;
  final String predictedDate;

  RecommendedCropData({
    required this.latitude,
    required this.longitude,
    required this.recommendedVegetable,
    required this.recommendedFruits,
    required this.locationProperties,
    required this.cropProperties,
    required this.predictedDate,
  });

  factory RecommendedCropData.fromJson(Map<String, dynamic> json) =>
      RecommendedCropData(
        latitude: json['latitude'],
        longitude: json['longitude'],
        recommendedVegetable: List<RecommendedVegetable>.from(
            json['recommended_vegetable']
                .map((x) => RecommendedVegetable.fromJson(x))),
        recommendedFruits: List<RecommendedFruit>.from(
            json['recommended_fruits']
                .map((x) => RecommendedFruit.fromJson(x))),
        locationProperties:
            LocationProperties.fromJson(json['location_properties']),
        cropProperties: List<CropProperty>.from(
            json['crop_properties'].map((x) => CropProperty.fromJson(x))),
        predictedDate: json['predicted_date'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'recommended_vegetable':
            recommendedVegetable.map((x) => x.toJson()).toList(),
        'recommended_fruits': recommendedFruits.map((x) => x.toJson()).toList(),
        'location_properties': locationProperties.toJson(),
        'crop_properties': cropProperties.map((x) => x.toJson()).toList(),
        'predicted_date': predictedDate,
      };
}

class RecommendedVegetable {
  final String vegetableName;
  final String vegetableNameEnglish;
  final String season;
  final String description;

  RecommendedVegetable({
    required this.vegetableName,
    required this.vegetableNameEnglish,
    required this.season,
    required this.description,
  });

  factory RecommendedVegetable.fromJson(Map<String, dynamic> json) =>
      RecommendedVegetable(
        vegetableName: json['vegetable_name'],
        vegetableNameEnglish: json['vegetable_name_english'],
        season: json['season'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'vegetable_name': vegetableName,
        'vegetable_name_english': vegetableNameEnglish,
        'season': season,
        'description': description,
      };
}

class RecommendedFruit {
  final String fruitName;
  final String fruitNameEnglish;
  final String season;
  final String description;

  RecommendedFruit({
    required this.fruitName,
    required this.fruitNameEnglish,
    required this.season,
    required this.description,
  });

  factory RecommendedFruit.fromJson(Map<String, dynamic> json) =>
      RecommendedFruit(
        fruitName: json['fruit_name'],
        fruitNameEnglish: json['fruit_name_english'],
        season: json['season'],
        description: json['description'],
      );

  Map<String, dynamic> toJson() => {
        'fruit_name': fruitName,
        'fruit_name_english': fruitNameEnglish,
        'season': season,
        'description': description,
      };
}

class LocationProperties {
  final double soilPh;
  final String soilPhosphorus;
  final String soilPotassium;
  final String soilNitrogen;
  final num altitude;
  final double weatherTemperature;
  final double weatherPrecipitation;
  final double weatherHumidity;

  LocationProperties({
    required this.soilPh,
    required this.soilPhosphorus,
    required this.soilPotassium,
    required this.soilNitrogen,
    required this.altitude,
    required this.weatherTemperature,
    required this.weatherPrecipitation,
    required this.weatherHumidity,
  });

  factory LocationProperties.fromJson(Map<String, dynamic> json) =>
      LocationProperties(
        soilPh: json['soil_ph'] is String
            ? double.parse(json['soil_ph'])
            : json['soil_ph'],
        soilPhosphorus: json['soil_phosphorus'],
        soilPotassium: json['soil_potassium'],
        soilNitrogen: json['soil_nitrogen'],
        altitude: json['Altitude'] is String
            ? _parseAltitude(json['Altitude'])
            : json['Altitude'],
        weatherTemperature: json['weather_temperature'] is String
            ? double.parse(json['weather_temperature'])
            : json['weather_temperature'],
        weatherPrecipitation: json['weather_precipitation'] is String
            ? double.parse(json['weather_precipitation'])
            : json['weather_precipitation'],
        weatherHumidity: json['weather_humidity'] is String
            ? double.parse(json['weather_humidity'])
            : json['weather_humidity'],
      );

  Map<String, dynamic> toJson() => {
        'soil_ph': soilPh,
        'soil_phosphorus': soilPhosphorus,
        'soil_potassium': soilPotassium,
        'soil_nitrogen': soilNitrogen,
        'Altitude': altitude,
        'weather_temperature': weatherTemperature,
        'weather_precipitation': weatherPrecipitation,
        'weather_humidity': weatherHumidity,
      };

  // Function to handle the altitude field (removes non-numeric characters)
  static num _parseAltitude(String altitude) {
    final numericString = altitude.replaceAll(
        RegExp(r'[^0-9.-]'), ''); // Remove non-numeric characters
    return double.tryParse(numericString) ?? 0; // Return 0 if parsing fails
  }
}

class CropProperty {
  final String name;
  final String soilPh;
  final String soilPhosphorus;
  final String soilPotassium;
  final String soilNitrogen;
  final String weatherTemperature;
  final String weatherPrecipitation;
  final String weatherHumidity;
  final num altitude;

  CropProperty({
    required this.name,
    required this.soilPh,
    required this.soilPhosphorus,
    required this.soilPotassium,
    required this.soilNitrogen,
    required this.weatherTemperature,
    required this.weatherPrecipitation,
    required this.weatherHumidity,
    required this.altitude,
  });

  factory CropProperty.fromJson(Map<String, dynamic> json) => CropProperty(
        name: json['Name'],
        soilPh: json['soil_ph'],
        soilPhosphorus: json['soil_phosphorus'],
        soilPotassium: json['soil_potassium'],
        soilNitrogen: json['soil_nitrogen'],
        weatherTemperature: json['weather_temperature'],
        weatherPrecipitation: json['weather_precipitation'],
        weatherHumidity: json['weather_humidity'],
        altitude: json['Altitude'] is String
            ? _parseAltitude(json['Altitude'])
            : json['Altitude'],
      );

  Map<String, dynamic> toJson() => {
        'Name': name,
        'soil_ph': soilPh,
        'soil_phosphorus': soilPhosphorus,
        'soil_potassium': soilPotassium,
        'soil_nitrogen': soilNitrogen,
        'weather_temperature': weatherTemperature,
        'weather_precipitation': weatherPrecipitation,
        'weather_humidity': weatherHumidity,
        'Altitude': altitude,
      };

  // Function to handle the altitude field (removes non-numeric characters)
  static num _parseAltitude(String altitude) {
    final numericString = altitude.replaceAll(
        RegExp(r'[^0-9.-]'), ''); // Remove non-numeric characters
    return double.tryParse(numericString) ?? 0; // Return 0 if parsing fails
  }
}
