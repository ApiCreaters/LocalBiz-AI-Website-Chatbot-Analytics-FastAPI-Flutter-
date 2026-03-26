// lib/controllers/chat_controller.dart
// ─────────────────────────────────────────────────────────
// GetX Controller — uses GetBuilder (NOT Obx)
// Handles POST /chat API calls

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ChatController extends GetxController {
  // ── State ─────────────────────────────────────────────
  List<ChatMessage> messages = [];
  bool isLoading = false;

  // ── API Config ────────────────────────────────────────
  // Same PC/browser  → http://localhost:8080
  // Android emulator → http://10.0.2.2:8080
  // Real phone       → http://YOUR_PC_IP:8080  (run ipconfig)
  static const String baseUrl = 'http://127.0.0.1:8080'; // ← YOUR IP

  @override
  void onInit() {
    super.onInit();
    messages.add(ChatMessage(
      text: '👋 Hi! I\'m the LocalBiz assistant. Try asking about our services, pricing, or how to get started!',
      isUser: false,
    ));
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(ChatMessage(text: text.trim(), isUser: true));
    isLoading = true;
    update(); // triggers GetBuilder rebuild

    try {
      final res = await http
          .post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text.trim()}),
      )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        messages.add(ChatMessage(
          text: data['response'] ?? 'No response.',
          isUser: false,
        ));
      } else {
        messages.add(ChatMessage(
          text: '⚠️ Server error (${res.statusCode}).',
          isUser: false,
        ));
      }
    } catch (e) {
      messages.add(ChatMessage(
        text: '❌ Cannot connect. Make sure backend is running on port 8080.',
        isUser: false,
      ));
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearChat() {
    messages.clear();
    messages.add(ChatMessage(
      text: '👋 Chat cleared. How can I help you?',
      isUser: false,
    ));
    update();
  }
}
