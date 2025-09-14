import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../core/secure_storage.dart';  // supaya bisa ambil token

class SoilService {
  Future<Map<String, dynamic>> analyze(File file, Map<String, String> fields) async {
    final req = http.MultipartRequest('POST', Uri.parse(API.analyzeSoil));

    // 👇 pakai field name yang sesuai dengan backend
    req.files.add(await http.MultipartFile.fromPath('file', file.path));

    // tambahkan form fields (location, ph, dll.)
    req.fields.addAll(fields);

    // ambil token dari secure storage
    final token = await SecureStorage.getToken();
    if (token != null) {
      req.headers['Authorization'] = 'Bearer $token';
      req.headers['Accept'] = 'application/json';
    }

    final res = await req.send();
    final r = await http.Response.fromStream(res);

    if (r.statusCode == 200) {
      return jsonDecode(r.body) as Map<String, dynamic>;
    }
    throw Exception('Analyze failed: ${r.statusCode} ${r.body}');
  }

  Future<List<Map<String, dynamic>>> history() async {
    final res = await http.get(
      Uri.parse(API.history),
      headers: {
        'Authorization': 'Bearer ${await SecureStorage.getToken()}',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    }
    throw Exception('History failed: ${res.statusCode} ${res.body}');
  }
}
