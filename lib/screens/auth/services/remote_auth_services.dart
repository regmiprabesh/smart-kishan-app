import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteAuthService {
  var client = http.Client();

  Future<dynamic> checkRegistration({
    required String phone,
  }) async {
    var data = {"phone": phone};
    var response = await client.post(
      Uri.parse('$apiUrl/auth/checkUser'),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(data),
    );
    return response;
  }

  Future<dynamic> signIn({
    required String phone,
    required String password,
  }) async {
    var body = {
      "phone": phone,
      "password": password,
    };
    var response = await client.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> signUp({
    required Map<String, dynamic> registerData,
  }) async {
    var body = registerData;
    var response = await client.post(
      Uri.parse('$apiUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> logout({required String token}) async {
    var response = await client.get(
      Uri.parse('$apiUrl/auth/logout'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    return response;
  }

  // Update Profile
  Future<dynamic> updateProfile({
    required String token,
    required String name,
    required String email,
    required String phone,
  }) async {
    var body = {
      "name": name,
      "email": email,
      "phone": phone,
    };
    var response = await client.post(
      Uri.parse('$apiUrl/users/update-profile'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  // Update Password
  Future<dynamic> updatePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    var body = {
      "current_password": currentPassword,
      "new_password": newPassword,
      "new_password_confirmation": confirmPassword,
    };
    var response = await client.post(
      Uri.parse('$apiUrl/users/update-password'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  // Update Location
  Future<dynamic> updateLocation({
    required String token,
    required String address,
    required int provinceId,
    required int districtId,
    required int municipalityId,
    required int wardId,
  }) async {
    var body = {
      "address": address,
      "province_id": provinceId,
      "district_id": districtId,
      "municipality_id": municipalityId,
      "ward_id": wardId,
    };
    var response = await client.post(
      Uri.parse('$apiUrl/users/update-location'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );
    return response;
  }

  // Upload Profile Image
  Future<dynamic> uploadProfileImage({
    required String token,
    required String imagePath,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/users/upload-profile-image'),
    );

    request.headers.addAll({
      "Authorization": "Bearer $token",
      "Accept": "application/json",
    });

    request.files.add(
      await http.MultipartFile.fromPath('image', imagePath),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return response;
  }

  // Get Provinces
  Future<Map<String, dynamic>> getProvinces() async {
    try {
      var response = await client.get(
        Uri.parse('$apiUrl/locations/provinces'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return {
          'success': true,
          'data': body['provinces'] ?? [],
        };
      }
      return {'success': false, 'data': []};
    } catch (e) {
      print('Error fetching provinces: $e');
      return {'success': false, 'data': []};
    }
  }

  // Get Districts by Province
  Future<Map<String, dynamic>> getDistricts(int provinceId) async {
    try {
      var response = await client.get(
        Uri.parse('$apiUrl/locations/provinces/$provinceId/districts'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return {
          'success': true,
          'data': body['districts'] ?? [],
        };
      }
      return {'success': false, 'data': []};
    } catch (e) {
      print('Error fetching districts: $e');
      return {'success': false, 'data': []};
    }
  }

  // Get Municipalities by District
  Future<Map<String, dynamic>> getMunicipalities(int districtId) async {
    try {
      var response = await client.get(
        Uri.parse('$apiUrl/locations/districts/$districtId/municipalities'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return {
          'success': true,
          'data': body['municipalities'] ?? [],
        };
      }
      return {'success': false, 'data': []};
    } catch (e) {
      print('Error fetching municipalities: $e');
      return {'success': false, 'data': []};
    }
  }

  // Get Wards by Municipality
  Future<Map<String, dynamic>> getWards(int municipalityId) async {
    try {
      var response = await client.get(
        Uri.parse('$apiUrl/locations/municipalities/$municipalityId/wards'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        return {
          'success': true,
          'data': body['wards'] ?? [],
        };
      }
      return {'success': false, 'data': []};
    } catch (e) {
      print('Error fetching wards: $e');
      return {'success': false, 'data': []};
    }
  }
}
