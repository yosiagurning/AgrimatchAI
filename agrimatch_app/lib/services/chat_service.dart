import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';

class ChatService {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String> send(int conversationId, String content) async {
    final token = await _getToken();

    final res = await http.post(
      Uri.parse("${API.chat}/$conversationId/message"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'content': content,
        'temperature': 0.2,
        'max_tokens': 128,
      }),
    );

    if (res.statusCode == 201) {
      final j = jsonDecode(res.body);
      return j['message']['content'] ?? '...';
    }
    throw Exception('Chat failed: ${res.statusCode} ${res.body}');
  }

  Future<int> createConversation(String title) async {
    final token = await _getToken();

    final res = await http.post(
      Uri.parse(API.chat),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'title': title}),
    );

    if (res.statusCode == 201) {
      final j = jsonDecode(res.body);
      return j['id'];
    }
    throw Exception('Create conversation failed: ${res.statusCode} ${res.body}');
  }

  Future<List<dynamic>> getConversations() async {
    final token = await _getToken();

    final res = await http.get(
      Uri.parse(API.chat),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Get conversations failed: ${res.statusCode} ${res.body}');
  }
}
