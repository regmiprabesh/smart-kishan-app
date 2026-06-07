import 'dart:convert';
import 'package:get/get.dart';
import 'package:smart_kishan/models/service_center.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_kishan/screens/service_center_screen/services/remote_service_center_service.dart';
import 'package:smart_kishan/screens/service_center_screen/services/routing_service.dart';
import 'package:latlong2/latlong.dart';

class ServiceCenterController extends GetxController {
  static ServiceCenterController instance = Get.find();

  RxList<ServiceCenterType> types =
      List<ServiceCenterType>.empty(growable: true).obs;
  RxList<ServiceCenter> serviceCenters =
      List<ServiceCenter>.empty(growable: true).obs;
  RxList<ServiceCenter> nearbyServiceCenters =
      List<ServiceCenter>.empty(growable: true).obs;

  Rx<ServiceCenter?> selectedServiceCenter = Rx<ServiceCenter?>(null);

  RxBool isTypesLoading = false.obs;
  RxBool isServiceCentersLoading = false.obs;
  RxBool isNearbyLoading = false.obs;
  RxBool isRating = false.obs;

  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxList<LatLng> routePoints = List<LatLng>.empty(growable: true).obs;
  Rx<double?> routeDistance = Rx<double?>(null);
  Rx<double?> routeDuration = Rx<double?>(null);
  RxBool isLoadingRoute = false.obs;

  // Filters
  Rx<ServiceCenterType?> selectedType = Rx<ServiceCenterType?>(null);
  RxString searchQuery = ''.obs;
  RxString sortBy = 'distance'.obs; // distance, name, rating, newest
  RxBool showFeaturedOnly = false.obs;
  RxDouble searchRadius = 50.0.obs; // km

  final LocalAuthService _localAuthService = LocalAuthService();

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    await getTypes();
    await getCurrentLocation();
    await getServiceCenters();
  }

  @override
  void onClose() {
    serviceCenters.clear();
    nearbyServiceCenters.clear();
    types.clear();
    super.onClose();
  }

  Future<void> getRouteToCenter(ServiceCenter center) async {
    if (currentPosition.value == null) return;

    try {
      isLoadingRoute(true);
      routePoints.clear();

      final route = await RoutingService.getRoute(
        LatLng(
            currentPosition.value!.latitude, currentPosition.value!.longitude),
        LatLng(center.latitude, center.longitude),
      );

      if (route != null) {
        routePoints.assignAll(route);
      }
    } catch (e) {
      print('Error getting route: $e');
    } finally {
      isLoadingRoute(false);
    }
  }

  void clearRoute() {
    routePoints.clear();
    routeDistance.value = null;
    routeDuration.value = null;
  }

  // Get user's current location
  Future<void> getCurrentLocation() async {
    currentPosition.value = Position(
      latitude: 27.7103,
      longitude: 85.3222,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
      altitudeAccuracy: 0,
      headingAccuracy: 0,
    );
    return;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;
      print('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  // Get all service center types
  Future<void> getTypes() async {
    try {
      isTypesLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteServiceCenterService().getTypes(token: token!);

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        print('Types response body type: ${body.runtimeType}');

        // Handle both array and object responses
        if (body is List) {
          types.assignAll(serviceCenterTypeListFromJson(jsonEncode(body)));
        } else if (body is Map && body.containsKey('data')) {
          types.assignAll(
              serviceCenterTypeListFromJson(jsonEncode(body['data'])));
        } else {
          print('Unexpected response format for types');
          types.clear();
        }
      }
    } catch (e) {
      print('Error fetching types: $e');
    } finally {
      isTypesLoading(false);
    }
  }

  // Get service centers with filters
  Future<void> getServiceCenters() async {
    try {
      isServiceCentersLoading(true);
      String? token = await _localAuthService.getToken();

      var result = await RemoteServiceCenterService().getServiceCenters(
        token: token!,
        typeId: selectedType.value?.id,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
        radius: searchRadius.value,
        featured: showFeaturedOnly.value ? true : null,
        sortBy: sortBy.value,
      );

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        print('Response body type: ${body.runtimeType}');
        print('Response body: $body');

        // Handle both array and object responses
        if (body is List) {
          serviceCenters.assignAll(serviceCenterListFromJson(jsonEncode(body)));
        } else if (body is Map && body.containsKey('data')) {
          serviceCenters
              .assignAll(serviceCenterListFromJson(jsonEncode(body['data'])));
        } else {
          print('Unexpected response format');
          serviceCenters.clear();
        }
      }
    } catch (e) {
      print('Error fetching service centers: $e');
    } finally {
      isServiceCentersLoading(false);
    }
  }

  // Get nearby service centers
  Future<void> getNearbyServiceCenters({double radius = 20}) async {
    if (currentPosition.value == null) {
      await getCurrentLocation();
      if (currentPosition.value == null) {
        print('Cannot get nearby centers without location');
        return;
      }
    }

    try {
      isNearbyLoading(true);
      String? token = await _localAuthService.getToken();

      var result = await RemoteServiceCenterService().getNearbyServiceCenters(
        token: token!,
        latitude: currentPosition.value!.latitude,
        longitude: currentPosition.value!.longitude,
        radius: radius,
      );

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        print('Nearby response body type: ${body.runtimeType}');

        // Handle both array and object responses
        if (body is List) {
          nearbyServiceCenters
              .assignAll(serviceCenterListFromJson(jsonEncode(body)));
        } else if (body is Map && body.containsKey('data')) {
          nearbyServiceCenters
              .assignAll(serviceCenterListFromJson(jsonEncode(body['data'])));
        } else {
          print('Unexpected response format');
          nearbyServiceCenters.clear();
        }
      }
    } catch (e) {
      print('Error fetching nearby service centers: $e');
    } finally {
      isNearbyLoading(false);
    }
  }

  // Get single service center details
  Future<void> getServiceCenterDetails(int id) async {
    try {
      String? token = await _localAuthService.getToken();
      var result = await RemoteServiceCenterService().getServiceCenter(
        token: token!,
        id: id,
      );

      if (result != null && result.statusCode == 200) {
        var body = jsonDecode(result.body);
        selectedServiceCenter.value = ServiceCenter.fromJson(body['data']);
      }
    } catch (e) {
      print('Error fetching service center details: $e');
    }
  }

  // Rate a service center
  Future<bool> rateServiceCenter(
    int serviceCenterId,
    int rating, {
    String? review,
  }) async {
    try {
      isRating(true);
      String? token = await _localAuthService.getToken();

      var result = await RemoteServiceCenterService().rateServiceCenter(
        token: token!,
        serviceCenterId: serviceCenterId,
        rating: rating,
        review: review,
      );

      if (result.statusCode == 200) {
        // Refresh service centers to update ratings
        await getServiceCenters();
        if (selectedServiceCenter.value?.id == serviceCenterId) {
          await getServiceCenterDetails(serviceCenterId);
        }
        return true;
      }
    } catch (e) {
      print('Error rating service center: $e');
    } finally {
      isRating(false);
    }
    return false;
  }

  // Get user's rating for a service center
  Future<Map<String, dynamic>?> getUserRating(int serviceCenterId) async {
    try {
      String? token = await _localAuthService.getToken();

      var result = await RemoteServiceCenterService().getUserRating(
        token: token!,
        serviceCenterId: serviceCenterId,
      );

      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        return body['data'];
      }
    } catch (e) {
      print('Error fetching user rating: $e');
    }
    return null;
  }

  // Delete user's rating
  Future<bool> deleteRating(int serviceCenterId) async {
    try {
      String? token = await _localAuthService.getToken();

      var result = await RemoteServiceCenterService().deleteRating(
        token: token!,
        serviceCenterId: serviceCenterId,
      );

      if (result.statusCode == 200) {
        await getServiceCenters();
        if (selectedServiceCenter.value?.id == serviceCenterId) {
          await getServiceCenterDetails(serviceCenterId);
        }
        return true;
      }
    } catch (e) {
      print('Error deleting rating: $e');
    }
    return false;
  }

  // Filter methods
  void setSelectedType(ServiceCenterType? type) {
    selectedType.value = type;
    clearRoute();
    getServiceCenters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    clearRoute();
    getServiceCenters();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    clearRoute();
    getServiceCenters();
  }

  void toggleFeaturedOnly() {
    showFeaturedOnly.value = !showFeaturedOnly.value;
    clearRoute();
    getServiceCenters();
  }

  void setSearchRadius(double radius) {
    searchRadius.value = radius;
    clearRoute();
    getServiceCenters();
  }

  void clearFilters() {
    selectedType.value = null;
    searchQuery.value = '';
    sortBy.value = 'distance';
    showFeaturedOnly.value = false;
    searchRadius.value = 50.0;
    clearRoute();
    getServiceCenters();
  }

  void reset() {
    serviceCenters.clear();
    nearbyServiceCenters.clear();
    types.clear();
    selectedServiceCenter.value = null;
    selectedType.value = null;
    searchQuery.value = '';
    sortBy.value = 'distance';
    showFeaturedOnly.value = false;
    isServiceCentersLoading(false);
    clearRoute();
    isRating(false);
  }
}
