import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    loadUserFromToken();
  }

  final _service = AuthService();
  User? user;
  bool loading = false;

  Future<void> login(String email, String password) async {
    loading = true;
    notifyListeners();
    try {
      await _service.login(email, password);
      // fetch profile after successful login
      final profile = await _service.me();
      user = User.fromJson(profile);
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> register(String email, String password,
      {String? fullName}) async {
    loading = true;
    notifyListeners();
    try {
      final data = await _service.register(email, password, fullName: fullName);
      try {
        final profile = await _service.me();
        user = User.fromJson(profile);
      } catch (_) {}
      return data;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.logout();
    user = null;
    notifyListeners();
  }

  /// Try to load user profile using saved token (if any).
  Future<void> loadUserFromToken() async {
    try {
      final profile = await _service.me();
      user = User.fromJson(profile);
      notifyListeners();
    } catch (e) {
      // ignore
    }
  }

Future<void> updateProfile(String name, String email, String phone) async {
  try {
    final updatedUser = await _service.updateProfile(name, email, phone);
    user = updatedUser; // update state
    notifyListeners();  // trigger UI rebuild
  } catch (e) {
    rethrow;
  }
}

Future<void> changePassword(String oldPassword, String newPassword) async {
  try {
    await _service.updatePassword(oldPassword, newPassword);
  } catch (e) {
    rethrow;
  }
}


  bool get isLoggedIn => user != null;
}
