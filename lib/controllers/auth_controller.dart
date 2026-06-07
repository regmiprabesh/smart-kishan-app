import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/constant.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/controllers/user_controller.dart';
import 'package:smart_kishan/models/user.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/auth/services/remote_auth_services.dart';
import 'package:smart_kishan/size_config.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final RemoteAuthService _remoteAuthService = RemoteAuthService();
  final LocalAuthService _localAuthService = LocalAuthService();

  Rxn<User> user = Rxn<User>();

  // Add a getter for easy access to current user
  Rx<User?> get currentUser => user;

  RxBool isRegisterLoading = false.obs;
  RxBool authStatusLoading = false.obs;

  String? fcmToken;

  @override
  void onInit() async {
    super.onInit();
    await _localAuthService.init();
    // fcmToken = await FirebaseMessaging.instance.getToken();
    SizeConfig().init(Get.overlayContext!);
    String? firstLaunch = _localAuthService.getFirstLaunch();
    if (firstLaunch != null) {
      await checkAuthStatus();
    } else {
      Get.offNamed(AppRoute.selectLanguageScreen);
    }
  }

  void signIn({required String phone, required String password}) async {
    if (authStatusLoading.value) return;
    try {
      authStatusLoading(true);
      var result = await RemoteAuthService().signIn(
        phone: '+977$phone',
        password: password,
      );
      print(result.body);
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        String token = body['token'];
        User getUser = User.fromJson(body['user']);
        await _localAuthService.addToken(token: token);
        await _localAuthService.addUser(
            user: jsonEncode(body['user']).toString());
        user(getUser);
        Get.offAllNamed(AppRoute.dashboard);
        getData();
      } else if (result.statusCode == 403) {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'गलत फोन / पासवर्ड',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      } else {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'केहि गलत भयो ! फेरि प्रयास गर्नुहोस',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      authStatusLoading(false);
    }
  }

  updateFirstLaunch() async {
    _localAuthService.addFirstLaunch(firstLaunch: 'false');
  }

  checkAuthStatus() async {
    try {
      authStatusLoading(true);

      String? token = await _localAuthService.getToken();
      String? userData = await _localAuthService.getUser();
      if (userData != null && token != null) {
        Map<String, dynamic> userMap = json.decode(userData);
        User userInfo = User.fromJson(userMap);
        user(userInfo);
        Get.offAllNamed(AppRoute.dashboard);
      } else {
        Get.offNamed(AppRoute.signInScreen);
        return;
      }
    } catch (e) {
      authStatusLoading(false);
      Get.offNamed(AppRoute.signInScreen);
      return;
    } finally {
      authStatusLoading(false);
    }
  }

  void signUp(
      {required String fullName,
      required String password,
      required String passwordConfirmation,
      String? email}) async {
    if (isRegisterLoading.value) return;
    try {
      isRegisterLoading(true);
      var result = await RemoteAuthService().signUp(registerData: {
        'name': fullName,
        'email': email,
        'password': password,
        'confirm_password': passwordConfirmation,
        'phone': otpController.phoneNumber.value,
        'phone_verification_id': otpController.otpVerificationId.value,
        'fcm_token': fcmToken
      });
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        String token = body['token'];
        await _localAuthService.addToken(token: token);
        Get.offAllNamed(AppRoute.dashboard);
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kSuccessColor,
            content: Text(
              'तपाईंको खाता सफलतापूर्वक सिर्जना गरिएको छ!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
        User userData = User.fromJson(body['user']);
        await _localAuthService.addUser(
            user: jsonEncode(body['user']).toString());
        user(userData);
      } else {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'केहि गलत भयो ! फेरि प्रयास गर्नुहोस',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      isRegisterLoading(false);
    } finally {
      isRegisterLoading(false);
    }
  }

  // Update Profile
  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      String? token = await _localAuthService.getToken();
      var result = await _remoteAuthService.updateProfile(
        token: token!,
        name: name,
        email: email,
        phone: phone,
      );
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        User updatedUser = User.fromJson(body['user']);
        await _localAuthService.addUser(
            user: jsonEncode(body['user']).toString());
        user(updatedUser);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update Profile Error: $e');
      return false;
    }
  }

  // Update Password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      String? token = await _localAuthService.getToken();
      var result = await _remoteAuthService.updatePassword(
        token: token!,
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (result.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update Password Error: $e');
      return false;
    }
  }

  // Update Location
  Future<bool> updateLocation({
    required String address,
    required int provinceId,
    required int districtId,
    required int municipalityId,
    required int wardId,
  }) async {
    try {
      String? token = await _localAuthService.getToken();
      var result = await _remoteAuthService.updateLocation(
        token: token!,
        address: address,
        provinceId: provinceId,
        districtId: districtId,
        municipalityId: municipalityId,
        wardId: wardId,
      );
      print(result.body);

      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        User updatedUser = User.fromJson(body['user']);
        await _localAuthService.addUser(
            user: jsonEncode(body['user']).toString());
        user(updatedUser);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Update Location Error: $e');
      return false;
    }
  }

  // Upload Profile Image
  Future<bool> uploadProfileImage(String imagePath) async {
    try {
      String? token = await _localAuthService.getToken();
      var result = await _remoteAuthService.uploadProfileImage(
        token: token!,
        imagePath: imagePath,
      );
      print(result.body);

      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        User updatedUser = User.fromJson(body['user']);
        await _localAuthService.addUser(
            user: jsonEncode(body['user']).toString());
        user(updatedUser);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Upload Profile Image Error: $e');
      return false;
    }
  }

  void logout() async {
    try {
      authStatusLoading(true);
      String? token = await _localAuthService.getToken();
      var result = await RemoteAuthService().logout(token: token!);
      if (result.statusCode == 200) {
        Get.offAllNamed(AppRoute.signInScreen);
        await _localAuthService.clear();
        await authController.updateFirstLaunch();
        user.value = null;
        await clearCache();
      } else {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(const SnackBar(
            backgroundColor: kErrorColor,
            content: Text(
              'Something went wrong! Please Try Again',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )));
      }
    } catch (e) {
      authStatusLoading(false);
    } finally {
      authStatusLoading(false);
    }
  }

  clearCache() {
    userController.reset();
    productController.reset();
    noteController.reset();
    dailyActivityController.reset();
    farmlandController.reset();
    buyProductsController.reset();
    buyersGroupController.reset();
    //cropCategoryController.reset();
    customerOrdersController.reset();
    productCartController.reset();
    searchHistoryController.reset();
    sellProductController.reset();
    vendorHomeController.reset();
    vendorOrdersController.reset();
    weatherController.reset();
    deliveryAddressController.reset();
    // Get.deleteAll();

    // Get.reset();
  }

  getData() {
    noteController.getNotes();
    productController.getUnits();
    productController.getProducts();
    dailyActivityController.getActivities();
    userController.getMyUsers();
    farmlandController.getFarmlands();
    vendorHomeController.getVendorStats();
    vendorOrdersController.getMyOrders();
    sellProductController.getSellProducts();
    sellProductController.getCropCategories();
    sellProductController.getDeliveryLocations();
    sellProductController.getPaymentTypes();
    sellProductController.getUnits();
    searchHistoryController.getSearchHistory();
    productCartController.getMyCartItems();
    customerOrdersController.getMyOrders();
    buyProductsController.getAllProducts();
    buyProductsController.getFeaturedProducts();
    buyProductsController.getDeliveryLocations();
    buyProductsController.getPaymentTypes();
    buyersGroupController.getBuyersGroups();
    cropCategoryController.getCropCategories();
    deliveryAddressController.getDeliveryAddress();
  }
}
