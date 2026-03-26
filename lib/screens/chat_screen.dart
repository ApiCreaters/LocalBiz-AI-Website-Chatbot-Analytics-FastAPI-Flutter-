// lib/screens/chat_screen.dart
// ─────────────────────────────────────────────────────────
// Chatbot screen — mirrors website demo section
// Uses GetBuilder (NOT Obx)

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_message.dart';
import '../theme/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  void _send(ChatController ctrl) {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    ctrl.sendMessage(text).then((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Bot avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child:
                    Text('🤖', style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('LocalBiz Assistant',
                    style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Text('● Online',
                    style: TextStyle(
                        color: AppColors.whatsapp,
                        fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          GetBuilder<ChatController>(
            builder: (ctrl) => IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.mint),
              tooltip: 'Clear Chat',
              onPressed: () {
                ctrl.clearChat();
                _scrollToBottom();
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.borderSoft),
        ),
      ),
      body: GetBuilder<ChatController>(
        builder: (ctrl) {
          return Column(
            children: [
              // ── Message list ───────────────────────────
              Expanded(
                child: ctrl.messages.isEmpty
                    ? const Center(
                        child: Text('No messages yet.',
                            style: TextStyle(
                                color: AppColors.textMuted)))
                    : ListView.builder(
                        controller: _scroll,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        itemCount: ctrl.messages.length,
                        itemBuilder: (_, i) =>
                            _Bubble(message: ctrl.messages[i]),
                      ),
              ),

              // ── Typing indicator ───────────────────────
              if (ctrl.isLoading)
                Container(
                  color: AppColors.bgDeep,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.green),
                      ),
                      SizedBox(width: 10),
                      Text('Typing…',
                          style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13)),
                    ],
                  ),
                ),

              // ── Input row ──────────────────────────────
              Container(
                color: AppColors.bg,
                padding:
                    const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _input,
                        enabled: !ctrl.isLoading,
                        style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 15),
                        decoration: InputDecoration(
                          hintText: 'Type your message…',
                          hintStyle: const TextStyle(
                              color: AppColors.textDim),
                          filled: true,
                          fillColor: AppColors.bgDeep,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 13),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.borderSoft),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.borderSoft),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: AppColors.green,
                                width: 1.5),
                          ),
                        ),
                        onSubmitted: (_) => _send(ctrl),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: ctrl.isLoading
                          ? null
                          : () => _send(ctrl),
                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 200),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: ctrl.isLoading
                              ? Colors.grey.shade800
                              : AppColors.green,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Bubble ─────────────────────────────────────────────────
class _Bubble extends StatelessWidget {
  final ChatMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                  child: Text('🤖',
                      style: TextStyle(fontSize: 14))),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.green
                    : AppColors.bg3,
                border: isUser
                    ? null
                    : Border.all(
                        color: AppColors.borderSoft),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft:
                      Radius.circular(isUser ? 14 : 4),
                  bottomRight:
                      Radius.circular(isUser ? 4 : 14),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : AppColors.mint,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.bg2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.person,
                    color: AppColors.mint, size: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
