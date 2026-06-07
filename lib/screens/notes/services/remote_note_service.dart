import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_kishan/constant.dart';

class RemoteNoteService {
  var client = http.Client();

  Future<dynamic> getNotes({required String token}) async {
    var remoteUrl = '$apiUrl/notes';
    var response = await client.get(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }

  Future<dynamic> addNote(
      {required String token, required Map<String, dynamic> data}) async {
    var remoteUrl = '$apiUrl/notes';
    var response = await client.post(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> updateNote(
      {required String token,
      required Map<String, dynamic> data,
      required int id}) async {
    var remoteUrl = '$apiUrl/notes/$id';
    var response = await client.put(Uri.parse(remoteUrl),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteNote({required String token, required int id}) async {
    var remoteUrl = '$apiUrl/notes/$id';
    var response = await client.delete(
      Uri.parse(remoteUrl),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response;
  }
}
