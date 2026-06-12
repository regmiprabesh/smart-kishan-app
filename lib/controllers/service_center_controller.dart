import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_kishan/models/service_center.dart';
import 'package:smart_kishan/screens/service_center_screen/services/remote_service_center_service.dart';
import 'package:smart_kishan/screens/service_center_screen/services/routing_service.dart';

class ServiceCenterController extends GetxController {
  // Lists
  final RxList<ServiceCenterType> types = <ServiceCenterType>[].obs;
  final RxList<ServiceCenter> serviceCenters = <ServiceCenter>[].obs;
  final RxList<ServiceCenter> nearbyServiceCenters = <ServiceCenter>[].obs;
  final Rx<ServiceCenter?> selectedServiceCenter = Rx<ServiceCenter?>(null);

  // Loading flags
  final RxBool isTypesLoading = false.obs;
  final RxBool isServiceCentersLoading = false.obs;
  final RxBool isNearbyLoading = false.obs;
  final RxBool isRating = false.obs;

  // Location & routing
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final Rx<double?> routeDistance = Rx<double?>(null);
  final Rx<double?> routeDuration = Rx<double?>(null);
  final RxBool isLoadingRoute = false.obs;

  // Filters
  final Rx<ServiceCenterType?> selectedType = Rx<ServiceCenterType?>(null);
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'distance'.obs; // distance | name | rating | newest
  final RxBool showFeaturedOnly = false.obs;
  final RxDouble searchRadius = 599.0.obs; // km

  // Set to false before releasing to production
  static const bool _useSimulatorLocation = true;

  @override
  void onInit() async {
    super.onInit();
    await Future.wait([getTypes(), getCurrentLocation()]);
    await getServiceCenters();
  }

  @override
  void onClose() {
    clearRoute();
    super.onClose();
  }

  // Location
  Future<void> getCurrentLocation() async {
    if (_useSimulatorLocation) {
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
    }

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      debugPrint('getCurrentLocation error: $e');
    }
  }

  // Routing
  Future<void> getRouteToCenter(ServiceCenter center) async {
    if (currentPosition.value == null) return;

    try {
      isLoadingRoute.value = true;
      routePoints.clear();

      final route = await RoutingService.getRoute(
        LatLng(
            currentPosition.value!.latitude, currentPosition.value!.longitude),
        LatLng(center.latitude, center.longitude),
      );

      if (route != null) routePoints.assignAll(route);
    } catch (e) {
      debugPrint('getRouteToCenter error: $e');
    } finally {
      isLoadingRoute.value = false;
    }
  }

  void clearRoute() {
    routePoints.clear();
    routeDistance.value = null;
    routeDuration.value = null;
  }

  // Data fetching
  Future<void> getTypes() async {
    try {
      isTypesLoading.value = true;
      final result = await RemoteServiceCenterService().getTypes();

      if (result.statusCode == 200) {
        final data = _decodeList(result.body);
        types.assignAll(serviceCenterTypeListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      debugPrint('getTypes error: $e');
    } finally {
      isTypesLoading.value = false;
    }
  }

  Future<void> getServiceCenters() async {
    try {
      isServiceCentersLoading.value = true;
      final result = await RemoteServiceCenterService().getServiceCenters(
        typeId: selectedType.value?.id,
        search: searchQuery.value.isEmpty ? null : searchQuery.value,
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
        radius: searchRadius.value,
        featured: showFeaturedOnly.value ? true : null,
        sortBy: sortBy.value,
      );
      if (result.statusCode == 200) {
        final data = _decodeList(result.body);
        serviceCenters.assignAll(serviceCenterListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      debugPrint('getServiceCenters error: $e');
    } finally {
      isServiceCentersLoading.value = false;
    }
  }

  Future<void> getNearbyServiceCenters({double radius = 20}) async {
    if (currentPosition.value == null) {
      await getCurrentLocation();
      if (currentPosition.value == null) return;
    }

    try {
      isNearbyLoading.value = true;
      final result = await RemoteServiceCenterService().getNearbyServiceCenters(
        latitude: currentPosition.value!.latitude,
        longitude: currentPosition.value!.longitude,
        radius: radius,
      );

      if (result.statusCode == 200) {
        final data = _decodeList(result.body);
        nearbyServiceCenters
            .assignAll(serviceCenterListFromJson(jsonEncode(data)));
      }
    } catch (e) {
      debugPrint('getNearbyServiceCenters error: $e');
    } finally {
      isNearbyLoading.value = false;
    }
  }

  Future<void> getServiceCenterDetails(int id) async {
    try {
      final result =
          await RemoteServiceCenterService().getServiceCenter(id: id);
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        selectedServiceCenter.value = ServiceCenter.fromJson(body['data']);
      }
    } catch (e) {
      debugPrint('getServiceCenterDetails error: $e');
    }
  }

  // Ratings
  Future<bool> rateServiceCenter(
    int serviceCenterId,
    int rating, {
    String? review,
  }) async {
    try {
      isRating.value = true;
      final result = await RemoteServiceCenterService().rateServiceCenter(
        serviceCenterId: serviceCenterId,
        rating: rating,
        review: review,
      );

      if (result.statusCode == 200) {
        await getServiceCenters();
        if (selectedServiceCenter.value?.id == serviceCenterId) {
          await getServiceCenterDetails(serviceCenterId);
        }
        return true;
      }
    } catch (e) {
      debugPrint('rateServiceCenter error: $e');
    } finally {
      isRating.value = false;
    }
    return false;
  }

  Future<Map<String, dynamic>?> getUserRating(int serviceCenterId) async {
    try {
      final result = await RemoteServiceCenterService()
          .getUserRating(serviceCenterId: serviceCenterId);
      if (result.statusCode == 200) {
        final body = jsonDecode(result.body);
        return body['data'] as Map<String, dynamic>?;
      }
    } catch (e) {
      debugPrint('getUserRating error: $e');
    }
    return null;
  }

  Future<bool> deleteRating(int serviceCenterId) async {
    try {
      final result = await RemoteServiceCenterService()
          .deleteRating(serviceCenterId: serviceCenterId);
      if (result.statusCode == 200) {
        await getServiceCenters();
        if (selectedServiceCenter.value?.id == serviceCenterId) {
          await getServiceCenterDetails(serviceCenterId);
        }
        return true;
      }
    } catch (e) {
      debugPrint('deleteRating error: $e');
    }
    return false;
  }

  // Filters
  void setSelectedType(ServiceCenterType? type) =>
      _applyFilter(() => selectedType.value = type);
  void setSearchQuery(String query) =>
      _applyFilter(() => searchQuery.value = query);
  void setSortBy(String sort) => _applyFilter(() => sortBy.value = sort);
  void setSearchRadius(double radius) =>
      _applyFilter(() => searchRadius.value = radius);
  void toggleFeaturedOnly() =>
      _applyFilter(() => showFeaturedOnly.value = !showFeaturedOnly.value);

  void clearFilters() => _applyFilter(() {
        selectedType.value = null;
        searchQuery.value = '';
        sortBy.value = 'distance';
        showFeaturedOnly.value = false;
        searchRadius.value = 50.0;
      });

  // Helpers
  List<dynamic> _decodeList(String body) {
    final decoded = jsonDecode(body);
    print(decoded.length);
    if (decoded is List) return decoded;
    if (decoded is Map && decoded.containsKey('data'))
      return decoded['data'] as List;
    return [];
  }

  void _applyFilter(void Function() mutation) {
    mutation();
    clearRoute();
    getServiceCenters();
  }
}
