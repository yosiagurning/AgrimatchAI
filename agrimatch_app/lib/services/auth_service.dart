
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/secure_storage.dart';
import '../models/user.dart';

class AuthService {
  /// Attempt to login and save token into secure storage.
  /// Returns the decoded JSON response from the login endpoint.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse(API.login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final decoded = jsonDecode(res.body);
      // common token keys: access_token, token
      final token = decoded['access_token'] ?? decoded['token'] ?? decoded['data']?['access_token'];
      if (token != null) {
        await SecureStorage.saveToken(token);
      }
      return decoded;
    } else {
      throw Exception("Login gagal: ${res.body}");
    }
  }

  Future<Map<String, dynamic>> register(String email, String password, {String? fullName}) async {
    final res = await http.post(
      Uri.parse(API.register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        if (fullName != null) "name": fullName,
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Register gagal: ${res.body}");
    }
  }

  Future<Map<String, dynamic>> me() async {
    final token = await SecureStorage.getToken();
    final res = await http.get(
      Uri.parse(API.me),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Gagal ambil profil: ${res.body}");
    }
  }

  Future<User?> updateProfile(String name, String email, String phone) async {
  final token = await SecureStorage.getToken();

  final res = await http.put(
    Uri.parse(API.update),
    headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    },
    body: jsonEncode({
      'full_name': name,
      'email': email,
      'phone': phone,
    }),
  );

  if (res.statusCode == 200) {
    if (res.body.isNotEmpty) {
      final data = jsonDecode(res.body);
      return User.fromJson(data);
    } else {
      return null; // backend tidak mengembalikan user
    }
  } else {
    throw Exception('Failed to update profile: ${res.statusCode} ${res.body}');
  }
}


Future<void> updatePassword(String oldPassword, String newPassword) async {
  final token = await SecureStorage.getToken();
  final res = await http.put(
    Uri.parse("${API.base}/api/auth/update-password"),
    headers: {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    },
    body: jsonEncode({
      "old_password": oldPassword,
      "new_password": newPassword,
    }),
  );

  if (res.statusCode != 200) {
    throw Exception("Gagal update password: ${res.body}");
  }
}



  Future<void> logout() async {
    await SecureStorage.clear();
  }
}
