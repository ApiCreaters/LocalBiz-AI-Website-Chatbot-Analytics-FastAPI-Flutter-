// lib/controllers/contact_controller.dart
// ─────────────────────────────────────────────────────────
// Handles POST /lead API call (contact form submission)

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'chat_controller.dart';

class ContactController extends GetxController {
  // ── State ─────────────────────────────────────────────
  bool isLoading  = false;
  bool isSuccess  = false;
  bool isError    = false;
  String statusMsg = '';

  void _reset() {
    isLoading = false;
    isSuccess = false;
    isError   = false;
    statusMsg = '';
  }

  Future<void> submitLead({
    required String name,
    required String email,
    required String message,
  }) async {
    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      isError   = true;
      statusMsg = '⚠️ Please fill in all fields.';
      update();
      return;
    }

    _reset();
    isLoading = true;
    update();

    try {
      final res = await http
          .post(
            Uri.parse('${ChatController.baseUrl}/lead'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name':    name,
              'email':   email,
              'message': message,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        isSuccess = true;
        statusMsg = '✅ Message sent! We\'ll be in touch soon.';
      } else {
        isError   = true;
        statusMsg = '❌ Server error. Please try again.';
      }
    } catch (e) {
      isError   = true;
      statusMsg = '❌ Could not connect. Check your connection.';
    } finally {
      isLoading = false;
      update();
    }
  }

  void clearStatus() {
    _reset();
    update();
  }
}
