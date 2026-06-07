import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/models/farmland.dart';
import 'package:smart_kishan/models/recommendedCrop.dart';
import 'package:smart_kishan/models/soildata.dart';
import 'package:smart_kishan/models/weather_model.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/farmland/services/local_farmland_service.dart';
import 'package:smart_kishan/screens/farmland/services/remote_farmland_service.dart';
import 'package:smart_kishan/screens/weather/services/remote_weather_service.dart';
import 'package:smart_kishan/sync_service.dart';
import 'package:http/http.dart' as http;

class FarmlandController extends GetxController {
  static FarmlandController instance = Get.find();

  RxList<Farmland> farmlands = List<Farmland>.empty(growable: true).obs;

  RxList<Farmland> offlineFarmlands = List<Farmland>.empty(growable: true).obs;

  final _localFarmlandService = LocalFarmlandService();

  RxBool isEdit = false.obs;

  Rx<Farmland> selectedFarmland = Farmland().obs;

  RxBool isFarmlandsLoading = false.obs;

  final LocalAuthService _localAuthService = LocalAuthService();
  final SyncService _syncService = SyncService();
  RxString selectedFarmlandImage = ''.obs;
  RxString networkFarmlandImage = ''.obs;
  RxString emptyString = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    await _localFarmlandService.init();
    await _syncService.init();
    getFarmlands();
    // getFarmlandsOffline();
  }

  @override
  void onClose() {
    farmlands.clear();
    offlineFarmlands.clear();
    super.onClose();
  }

  Comparator<Farmland> sortById = (a, b) => b.id!.compareTo(a.id!);

  void getFarmlands() async {
    try {
      isFarmlandsLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteFarmlandService().getFarmlands(token: token!);
      if (result != null) {
        var body = jsonDecode(result.body);
        farmlands.assignAll(farmlandListFromJson(jsonEncode(body['data'])));
        print(farmlands);
        // var data = await _localFarmlandService.readFarmlands();
        // offlineFarmlands.assignAll(farmlandListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      print(e);
      print('No Internet Connection');
      // getFarmlandsOffline();
      // } finally {
      //   isFarmlandsLoading(false);
    }
  }

  getFarmlandsOffline() async {
    try {
      var data = await _localFarmlandService.readFarmlands();
      farmlands.assignAll(farmlandListFromJson(jsonEncode(data)));
      offlineFarmlands.assignAll(farmlandListFromJson(jsonEncode(data)));
      // You can sort the list by id like this
      farmlands.sort(sortById);
    } catch (e) {
      print(e);
    } finally {}
  }

  Future<bool> addFarmland(Farmland farmland, bool isSync) async {
    // try {
    isFarmlandsLoading(true);
    String? token = await _localAuthService.getToken();
    var image;
    if (farmland.image != null) {
      image = await http.MultipartFile.fromPath('image', farmland.image!);
    }
    var result = await RemoteFarmlandService()
        .addFarmland(token: token!, data: farmland.toJson(), image: image);
    if (result.statusCode == 200) {
      var body = jsonDecode(result.body);
      var newFarmland = Farmland.fromJson(body['data']);
      farmlands.add(newFarmland);
      Get.back();
    }
    // } catch (e) {
    // if (isSync) {
    //   return false;
    // }
    // int? farmlandId = await addFarmlandOffline(farmland);
    // Sync data =
    //     Sync(objectID: farmlandId!, objectType: 'Farmland', changeType: 'create');
    // _syncService.addSyncData(data);
    // return false;
    // } finally {
    //   isFarmlandsLoading(false);
    // }
    return false;
  }

  Future<int?>? addFarmlandOffline(Farmland farmland) async {
    try {
      var result = await _localFarmlandService.saveFarmland(farmland);
      // print(result);
      if (result > 0) {
        Get.back();
        await getFarmlandsOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक थपियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
        return result;
      }
    } catch (e) {
      print(e);
    } finally {}
    return null;
  }

  void updateFarmland(Farmland farmland) async {
    // try {
    isFarmlandsLoading(true);
    String? token = await _localAuthService.getToken();
    var image;
    if (farmland.image != null) {
      image = await http.MultipartFile.fromPath('image', farmland.image!);
    }
    var result = await RemoteFarmlandService().updateFarmland(
        token: token!, data: farmland.toJson(), id: farmland.id!, image: image);
    print(result.body);
    if (result.statusCode == 200) {
      var body = jsonDecode(result.body);
      Farmland updatedData = Farmland.fromJson(body['data']);
      farmlands[farmlands
          .indexWhere((element) => element.id == updatedData.id)] = updatedData;
      farmlands.refresh();
      // updateFarmlandOffline(farmland);
      Get.back();
      Get.back();
    }
    // } catch (e) {
    //   // updateFarmlandOffline(farmland);
    // } finally {
    //   isFarmlandsLoading(false);
    // }
  }

  updateFarmlandOffline(Farmland farmland, [bool? isSync]) async {
    try {
      var result = await _localFarmlandService.updateFarmland(farmland);
      if (result > 0) {
        Get.back();
        await getFarmlandsOffline();
        if (isSync != null && isSync) {
          return;
        }
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक अद्यावधिक गरियो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      print(e);
    } finally {}
  }

  void deleteFarmland(int id) async {
    try {
      isFarmlandsLoading(true);
      String? token = await _localAuthService.getToken();
      var result =
          await RemoteFarmlandService().deleteFarmland(token: token!, id: id);
      if (result.statusCode == 200) {
        farmlands.removeWhere((element) => element.id == id);
        // deleteFarmlandOffline(id);
        Get.back();
      }
    } catch (e) {
      // deleteFarmlandOffline(id);
    } finally {
      isFarmlandsLoading(false);
    }
  }

  deleteFarmlandOffline(int id) async {
    try {
      var result = await _localFarmlandService.deleteFarmland(id);
      if (result > 0) {
        Get.back();
        getFarmlandsOffline();
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'नोट सफलतापूर्वक मेटाइयो!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
    } finally {}
  }

  Future<Map<String, double>?> getMyLatLng() async {
    double lat = 27.649853363922848;
    double lng = 85.32217108129528;
    return {'lat': lat, 'lng': lng};
  }

  Future<String>? getSoilApiKey() async {
    var result = await RemoteFarmlandService().getSoilApiKey(data: {
      'email': 'regmiprabesh@gmail.com',
      'password': 'fVWZN3gcG2PnqM@'
    });
    String token = '';
    try {
      var body = jsonDecode(result.body);
      token = body['access'];
    } catch (e) {}
    return token;
  }

  Future<SoilData?>? getSoilProperty(Coordinates? coordinates) async {
    if (coordinates != null &&
        coordinates.lat != null &&
        coordinates.lng != null) {
      String? token = await getSoilApiKey();
      var result = await RemoteFarmlandService()
          .getSoilData(data: coordinates, token: token);
      var body = jsonDecode(result.body);
      SoilData soilData = SoilData.fromJson(body);
      return soilData;
    }
    return null;
  }

  Future<Weather?> getCurrentWeather() async {
    try {
      var result = await RemoteWeatherService().getWeather(
          Coordinates(lat: 27.650061458918543, lng: 85.32219631281998));
      Weather? weather = Weather.fromJson(jsonDecode(result.body));
      return weather;
    } catch (e) {
      print(e);
    }
    return null;
  }

  void reset() {
    farmlands.clear();
    offlineFarmlands.clear();
    isEdit(false);
    selectedFarmland(null);
    isFarmlandsLoading(false);
  }

  Future<RecommendedCropData?> getRecommendedCrop(
      {required Coordinates coordinate}) async {
    try {
      var result = await RemoteFarmlandService().getRecommendedCrop(
          coordinate: Coordinates(lat: coordinate.lat, lng: coordinate.lng));
      var data = jsonDecode(result.body);
      RecommendedCropData recommendedCrop = RecommendedCropData.fromJson(data);
      return recommendedCrop;
    } catch (e) {
      print(e);
    }
    return null;
  }
}
