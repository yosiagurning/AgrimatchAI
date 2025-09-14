import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  final _svc = ChatService();
  final messages = <ChatMessage>[];
  bool sending = false;
  final _uuid = const Uuid();
  int? conversationId;

  Future<void> startConversation(String title) async {
    conversationId = await _svc.createConversation(title);
    notifyListeners();
  }

  Future<void> send(String text) async {
    if (conversationId == null) {
      // otomatis bikin conversation kalau belum ada
      conversationId = await _svc.createConversation("New Chat");
    }

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      text: text,
      isUser: true,
      time: DateTime.now(),
    );
    messages.add(userMsg);

    sending = true;
    notifyListeners();
    try {
      final reply = await _svc.send(conversationId!, text);
      messages.add(ChatMessage(
        id: _uuid.v4(),
        text: reply,
        isUser: false,
        time: DateTime.now(),
      ));
    } finally {
      sending = false;
      notifyListeners();
    }
  }

  void clear() {
    messages.clear();
    conversationId = null;
    notifyListeners();
  }
}
