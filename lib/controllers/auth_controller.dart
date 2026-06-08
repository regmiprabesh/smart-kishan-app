import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_kishan/controllers/app_controller.dart';
import 'package:smart_kishan/models/user.dart';
import 'package:smart_kishan/routes/app_routes.dart';
import 'package:smart_kishan/screens/auth/services/local_auth_service.dart';
import 'package:smart_kishan/screens/auth/services/remote_auth_services.dart';
import 'package:smart_kishan/size_config.dart';
import 'package:smart_kishan/helpers/l10n.dart';
import 'package:smart_kishan/helpers/app_snackbar.dart';
import 'package:smart_kishan/helpers/app_mode.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  final RemoteAuthService _remoteAuthService = RemoteAuthService();
  final LocalAuthService _localAuthService = LocalAuthService();

  Rxn<User> user = Rxn<User>();

  Rx<User?> get currentUser => user;

  RxBool isRegisterLoading = false.obs;
  RxBool authStatusLoading = false.obs;

  String? fcmToken;

  RxBool isResetLoading = false.obs;

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
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        String token = body['token'];
        User getUser = User.fromJson(body['user']);
        await _localAuthService.addToken(token: token);
        await _localAuthService.addUser(
            user: jsonEncode(body['user']).toString());
        user(getUser);
        // seed local mode cache from the server's value
        final mode = (getUser.mode != null && getUser.mode!.isNotEmpty)
            ? getUser.mode!
            : AppMode.farmer;
        await _localAuthService.setMode(mode: mode);
        Get.offAllNamed(routeForMode(mode));
        // if (getUser.mode != null && getUser.mode!.isNotEmpty) {
        //   await _localAuthService.setMode(mode: getUser.mode!);
        // }
        // Get.offAllNamed(routeForMode(_localAuthService.getMode()));
        getData();
      } else if (result.statusCode == 429) {
        var body = json.decode(result.body);
        int seconds = body['retry_after'] ?? 60;
        showErrorSnackbar(l10n.loginThrottled(localizedNumber(seconds)));
      } else if (result.statusCode == 403) {
        showErrorSnackbar(l10n.wrongPhonePassword);
      } else {
        print('Sign In Failed: ${result.statusCode} - ${result.body}');
        showErrorSnackbar(l10n.genericError);
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
        // route to the last-used mode (cached locally, offline-safe)
        Get.offAllNamed(routeForMode(_localAuthService.getMode()));
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

  void signUp({
    required String fullName,
    required String password,
    required String passwordConfirmation,
    String? email,
  }) async {
    if (isRegisterLoading.value) return;
    try {
      isRegisterLoading(true);
      var result = await RemoteAuthService().signUp(registerData: {
        'name': fullName,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': otpController.phoneNumber.value,
        'verification_token': otpController.verificationToken.value,
        'fcm_token': fcmToken,
      });
      if (result.statusCode == 200) {
        var body = jsonDecode(result.body);
        String token = body['token'];
        await _localAuthService.addToken(token: token);
        User userData = User.fromJson(body['user']);
        await _localAuthService.addUser(
            user: jsonEncode(body['user']).toString());
        user(userData);
        // seed local mode cache (new accounts default to farmer on the backend)
        final mode = (userData.mode != null && userData.mode!.isNotEmpty)
            ? userData.mode!
            : AppMode.farmer;
        await _localAuthService.setMode(mode: mode);
        Get.offAllNamed(routeForMode(mode));
        // if (userData.mode != null && userData.mode!.isNotEmpty) {
        //   await _localAuthService.setMode(mode: userData.mode!);
        // }
        // Get.offAllNamed(routeForMode(_localAuthService.getMode()));
        showSuccessSnackbar(l10n.accountCreated);
      } else {
        print('Sign Up Failed: ${result.statusCode} - ${result.body}');
        showErrorSnackbar(l10n.genericError);
      }
    } catch (e) {
      isRegisterLoading(false);
    } finally {
      isRegisterLoading(false);
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      var result = await _remoteAuthService.updateProfile(
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

  Future<bool> uploadProfileImage(String imagePath) async {
    try {
      String? token = await _localAuthService.getToken();
      var result = await _remoteAuthService.uploadProfileImage(
        token: token!,
        imagePath: imagePath,
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
      debugPrint('Upload Profile Image Error: $e');
      return false;
    }
  }

  void logout() async {
    try {
      authStatusLoading(true);
      var result = await RemoteAuthService().logout();
      if (result.statusCode == 200) {
        Get.offAllNamed(AppRoute.signInScreen);
        await _localAuthService.clear();
        await authController.updateFirstLaunch();
        user.value = null;
        await clearCache();
      } else {
        showErrorSnackbar(l10n.logoutFailed);
      }
    } catch (e) {
      authStatusLoading(false);
    } finally {
      authStatusLoading(false);
    }
  }

  void resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    if (isResetLoading.value) return;
    if (password != confirmPassword) {
      showErrorSnackbar(l10n.passwordsDoNotMatch);
      return;
    }
    try {
      isResetLoading(true);
      var result = await _remoteAuthService.resetPassword(
        phone: otpController.rawPhone.value,
        verificationToken: otpController.verificationToken.value,
        password: password,
        passwordConfirmation: confirmPassword,
      );
      if (result.statusCode == 200) {
        otpController.verificationToken('');
        Get.offAllNamed(AppRoute.signInScreen);
        showSuccessSnackbar(l10n.passwordResetSuccess);
      } else {
        var body = jsonDecode(result.body);
        showErrorSnackbar(body['message'] != null
            ? body['message'] as String
            : l10n.passwordResetFailed);
      }
    } catch (e) {
      debugPrint('Reset Password Error: $e');
    } finally {
      isResetLoading(false);
    }
  }

  Future<void> forceExpiredLogout() async {
    await _localAuthService.clear();
    user.value = null;
    if (Get.currentRoute != AppRoute.signInScreen) {
      Get.offAllNamed(AppRoute.signInScreen);
    }
    showErrorSnackbar(l10n.sessionExpired);
  }

  Future<void> switchMode(String mode) async {
    await _localAuthService.setMode(mode: mode);
    if (user.value != null) {
      user.value!.mode = mode;
      user.refresh();
    }
    Get.offAllNamed(routeForMode(mode));
    try {
      await _remoteAuthService.updateMode(mode: mode); // background sync
    } catch (_) {
      // offline: local cache already updated, will resync on next switch/login
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
    customerOrdersController.reset();
    productCartController.reset();
    searchHistoryController.reset();
    sellProductController.reset();
    vendorHomeController.reset();
    vendorOrdersController.reset();
    weatherController.reset();
    deliveryAddressController.reset();
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
    buyersGroupController.getBuyersGroups();
    cropCategoryController.getCropCategories();
    deliveryAddressController.getDeliveryAddress();
  }
}
