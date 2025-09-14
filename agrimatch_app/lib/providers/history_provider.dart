import 'package:flutter/material.dart';
import '../models/soil_analysis.dart';
import '../services/soil_service.dart';

class HistoryProvider extends ChangeNotifier {
  final _svc = SoilService();
  List<SoilAnalysis> histories = [];
  bool loading = false;

  Future<void> fetchHistory() async {
    loading = true;
    notifyListeners();
    try {
      final list = await _svc.history();
      histories = list.map((e) => SoilAnalysis.fromJson(e)).toList();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
