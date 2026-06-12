import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/models/farmland.dart';
import 'package:smart_kishan/models/recommendedCrop.dart';
import 'package:smart_kishan/models/soildata.dart';
import 'package:smart_kishan/models/weather_model.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/farmland/services/remote_farmland_service.dart';
import 'package:smart_kishan/screens/weather/services/remote_weather_service.dart';
import 'package:http/http.dart' as http;

class FarmlandController extends GetxController {
  static FarmlandController get instance => Get.find();

  final RxList<Farmland> farmlands = <Farmland>[].obs;

  final RxBool isEdit = false.obs;
  final Rx<Farmland> selectedFarmland = Farmland().obs;
  final RxBool isFarmlandsLoading = false.obs;

  final RxString selectedFarmlandImage = ''.obs;
  final RxString networkFarmlandImage = ''.obs;
  final RxString emptyString = ''.obs;

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    getFarmlands();
  }

  @override
  void onClose() {
    farmlands.clear();
    super.onClose();
  }

  void getFarmlands() async {
    try {
      isFarmlandsLoading(true);
      final result = await RemoteFarmlandService().getFarmlands();
      if (result != null) {
        final body = jsonDecode(result.body);
        farmlands.assignAll(farmlandListFromJson(jsonEncode(body['data'])));
      }
    } catch (e) {
      debugPrint('getFarmlands error: $e');
    } finally {
      isFarmlandsLoading(false);
    }
  }

  Future<bool> addFarmland(Farmland farmland) async {
    try {
      isFarmlandsLoading(true);
      http.MultipartFile? image;
      if (farmland.image != null) {
        image = await http.MultipartFile.fromPath('image', farmland.image!);
      }
      final result = await RemoteFarmlandService()
          .addFarmland(data: farmland.toJson(), image: image);
      print(result.body);
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        farmlands.add(Farmland.fromJson(body['data']));
        Get.back();
        return true;
      }
    } catch (e) {
      debugPrint('addFarmland error: $e');
    } finally {
      isFarmlandsLoading(false);
    }
    return false;
  }

  void updateFarmland(Farmland farmland) async {
    try {
      isFarmlandsLoading(true);
      http.MultipartFile? image;
      if (farmland.image != null) {
        image = await http.MultipartFile.fromPath('image', farmland.image!);
      }
      final result = await RemoteFarmlandService().updateFarmland(
          data: farmland.toJson(), id: farmland.id!, image: image);
      if (result.statusCode == 200) {
        final updatedData = Farmland.fromJson(jsonDecode(result.body)['data']);
        final i = farmlands.indexWhere((e) => e.id == updatedData.id);
        if (i != -1) farmlands[i] = updatedData;
        Get.back();
        Get.back();
      }
    } catch (e) {
      debugPrint('updateFarmland error: $e');
    } finally {
      isFarmlandsLoading(false);
    }
  }

  void deleteFarmland(int id) async {
    try {
      isFarmlandsLoading(true);
      final result = await RemoteFarmlandService().deleteFarmland(id: id);
      if (result.statusCode == 200) {
        farmlands.removeWhere((e) => e.id == id);
        Get.back();
      }
    } catch (e) {
      debugPrint('deleteFarmland error: $e');
    } finally {
      isFarmlandsLoading(false);
    }
  }

  Future<Map<String, double>?> getMyLatLng() async {
    const double lat = 27.649853363922848;
    const double lng = 85.32217108129528;
    return {'lat': lat, 'lng': lng};
  }

  Future<String> getSoilApiKey() async {
    try {
      final result = await RemoteFarmlandService().getSoilApiKey(data: {
        'email': 'regmiprabesh@gmail.com',
        'password': 'fVWZN3gcG2PnqM@'
      });
      final body = jsonDecode(result.body);
      return body['access'] as String? ?? '';
    } catch (e) {
      debugPrint('getSoilApiKey error: $e');
      return '';
    }
  }

  Future<SoilData?> getSoilProperty(Coordinates? coordinates) async {
    if (coordinates?.lat == null || coordinates?.lng == null) return null;
    try {
      final token = await getSoilApiKey();
      final result = await RemoteFarmlandService()
          .getSoilData(data: coordinates!, token: token);
      return SoilData.fromJson(jsonDecode(result.body));
    } catch (e) {
      debugPrint('getSoilProperty error: $e');
      return null;
    }
  }

  Future<Weather?> getCurrentWeather() async {
    try {
      final result = await RemoteWeatherService().getWeather(
          Coordinates(lat: 27.650061458918543, lng: 85.32219631281998));
      return Weather.fromJson(jsonDecode(result.body));
    } catch (e) {
      debugPrint('getCurrentWeather error: $e');
      return null;
    }
  }

  Future<RecommendedCropData?> getRecommendedCrop(
      {required Coordinates coordinate}) async {
    try {
      final result = await RemoteFarmlandService().getRecommendedCrop(
          coordinate: Coordinates(lat: coordinate.lat, lng: coordinate.lng));
      return RecommendedCropData.fromJson(jsonDecode(result.body));
    } catch (e) {
      debugPrint('getRecommendedCrop error: $e');
      return null;
    }
  }
}
