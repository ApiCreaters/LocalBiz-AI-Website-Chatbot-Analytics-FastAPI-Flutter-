// lib/screens/contact_screen.dart
// ─────────────────────────────────────────────────────────
// Contact screen — mirrors website contact section
// Submits to POST /lead, uses GetBuilder

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/contact_controller.dart';
import '../theme/app_colors.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});
  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();

  void _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/1234567890');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _openEmail() async {
    final uri = Uri.parse('mailto:hello@localbiz.com');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Contact Us',
            style: TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.w700,
                fontSize: 18)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child:
              Container(height: 1, color: AppColors.borderSoft),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            const Text(
              'GET IN TOUCH',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.green),
            ),
            const SizedBox(height: 8),
            const Text(
              "Let's Talk About\nYour Business",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textLight,
                  height: 1.2),
            ),
            const SizedBox(height: 10),
            const Text(
              "Ready to simplify how you manage customers? Drop us a message and we'll be in touch shortly.",
              style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textMuted,
                  height: 1.6),
            ),
            const SizedBox(height: 28),

            // ── Contact Info Cards ───────────────────────
            _ContactInfoRow(
              icon: '📍',
              label: 'Location',
              value: '123 Main Street, Your City',
              onTap: null,
            ),
            const SizedBox(height: 12),
            _ContactInfoRow(
              icon: '📧',
              label: 'Email',
              value: 'hello@localbiz.com',
              onTap: _openEmail,
            ),
            const SizedBox(height: 12),
            _ContactInfoRow(
              icon: '💬',
              label: 'WhatsApp',
              value: '+1 234 567 890',
              onTap: _openWhatsApp,
              valueColor: AppColors.green,
            ),
            const SizedBox(height: 32),

            // ── Form ────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bg3,
                border: Border.all(
                    color: AppColors.green.withOpacity(0.25)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Send Us a Message',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight),
                  ),
                  const SizedBox(height: 20),

                  // Name
                  _FormField(
                    label: 'Full Name',
                    hint: 'John Smith',
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),

                  // Email
                  _FormField(
                    label: 'Email Address',
                    hint: 'john@email.com',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Message
                  _FormField(
                    label: 'Message',
                    hint: 'Tell us about your business…',
                    controller: _messageCtrl,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),

                  // Submit button + status
                  GetBuilder<ContactController>(
                    builder: (ctrl) {
                      return Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: ctrl.isLoading
                                ? null
                                : () async {
                                    await ctrl.submitLead(
                                      name: _nameCtrl.text,
                                      email: _emailCtrl.text,
                                      message:
                                          _messageCtrl.text,
                                    );
                                    if (ctrl.isSuccess) {
                                      _nameCtrl.clear();
                                      _emailCtrl.clear();
                                      _messageCtrl.clear();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.green,
                              foregroundColor:
                                  AppColors.white,
                              disabledBackgroundColor:
                                  Colors.grey.shade800,
                              padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 15),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          8)),
                            ),
                            child: ctrl.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Send Message →',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w700),
                                  ),
                          ),

                          // Status message
                          if (ctrl.statusMsg.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              ctrl.statusMsg,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ctrl.isSuccess
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── WhatsApp CTA ─────────────────────────────
            GestureDetector(
              onTap: _openWhatsApp,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.whatsapp.withOpacity(0.1),
                  border: Border.all(
                      color:
                          AppColors.whatsapp.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Text('💬',
                        style: TextStyle(fontSize: 28)),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('Chat on WhatsApp',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whatsapp)),
                          SizedBox(height: 2),
                          Text(
                              'Get instant replies on WhatsApp',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColors.whatsapp),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // ── Footer ──────────────────────────────────
            const Center(
              child: Text(
                '© 2025 LocalBiz — Built with ♥ for small businesses.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textDim),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Contact Info Row ───────────────────────────────────────
class _ContactInfoRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Color valueColor;

  const _ContactInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.valueColor = AppColors.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bg3,
          border: Border.all(color: AppColors.borderSoft),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                  child: Text(icon,
                      style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontSize: 14, color: valueColor)),
              ],
            ),
            if (onTap != null) ...[
              const Spacer(),
              const Icon(Icons.arrow_forward_ios,
                  size: 14, color: AppColors.textMuted),
            ]
          ],
        ),
      ),
    );
  }
}

// ── Form Field ─────────────────────────────────────────────
class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType keyboardType;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.mint)),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(
              color: AppColors.textLight, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: AppColors.textDim),
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: AppColors.borderSoft),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: AppColors.borderSoft),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                  color: AppColors.green, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
