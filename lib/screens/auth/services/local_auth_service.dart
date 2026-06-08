import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalAuthService {
  late SharedPreferences _localStorage;
  late FlutterSecureStorage _securedStrorage;

  Future<void> init() async {
    _localStorage = await SharedPreferences.getInstance();
    _securedStrorage = const FlutterSecureStorage();
  }

  Future<void> addToken({required String token}) async {
    await _securedStrorage.write(key: 'jwt', value: token);
  }

  Future<void> addUser({required String user}) async {
    await _localStorage.setString('user', user);
    print(user);
  }

  Future<void> addFirstLaunch({required String firstLaunch}) async {
    await _localStorage.setString('firstLaunch', firstLaunch);
  }

  Future<String?> getUser() async => _localStorage.getString('user');

  Future<void> clear() async {
    await _localStorage.remove('user');
    await _localStorage.remove('appMode');
    await _securedStrorage.delete(key: 'jwt');
  }

  Future<String?> getToken() async => await _securedStrorage.read(key: 'jwt');

  String? getFirstLaunch() => _localStorage.getString('firstLaunch');

  Future<void> setMode({required String mode}) async {
    await _localStorage.setString('appMode', mode);
  }

  String? getMode() => _localStorage.getString('appMode');
}
