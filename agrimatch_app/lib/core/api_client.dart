import 'dart:convert';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';

class ApiClient {
  final String baseUrl;
  ApiClient(this.baseUrl);

  Future<Map<String, String>> _authHeader() async { 
    final token = await SecureStorage.getToken();
    final h = <String, String>{'Content-Type': 'application/json'};
    if (token != null) h['Authorization'] = 'Bearer $token';
    return h;
  }

  Future<http.Response> get(Uri uri) async => http.get(uri, headers: await _authHeader());

  Future<http.Response> post(Uri uri, Map<String, dynamic> body) async =>
      http.post(uri, headers: await _authHeader(), body: jsonEncode(body));
}
