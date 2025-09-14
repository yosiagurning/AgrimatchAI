import 'dart:io';
import 'package:flutter/material.dart';
import '../models/soil_analysis.dart';
import '../services/soil_service.dart';

class SoilProvider extends ChangeNotifier {
  final _svc = SoilService();
  SoilAnalysis? lastResult;
  bool loading = false;

  Future<void> analyze(File file, Map<String, String> fields) async {
    loading = true; notifyListeners();
    try {
      final res = await _svc.analyze(file, fields);
      lastResult = SoilAnalysis.fromJson(res);
    } finally {
      loading = false; notifyListeners();
    }
  }
}
