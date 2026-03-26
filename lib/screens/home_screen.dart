// lib/screens/home_screen.dart
// ─────────────────────────────────────────────────────────
// Scrollable home page: Hero → About → Services → How It Works

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openWhatsApp() async {
    final uri = Uri.parse('https://wa.me/1234567890');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ─────────────────────────────────────
          SliverAppBar(
            backgroundColor: AppColors.bg,
            pinned: true,
            elevation: 0,
            title: RichText(
              text: const TextSpan(
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800),
                children: [
                  TextSpan(
                      text: 'Local',
                      style: TextStyle(color: AppColors.textLight)),
                  TextSpan(
                      text: 'Biz',
                      style: TextStyle(color: AppColors.green)),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: _openWhatsApp,
                icon: const Text('💬', style: TextStyle(fontSize: 14)),
                label: const Text('WhatsApp',
                    style: TextStyle(
                        color: AppColors.whatsapp,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                  height: 1, color: AppColors.borderSoft),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              _HeroSection(onWhatsApp: _openWhatsApp),
              const _AboutSection(),
              const _ServicesSection(),
              const _HowItWorksSection(),
              const SizedBox(height: 24),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── HERO ──────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final VoidCallback onWhatsApp;
  const _HeroSection({required this.onWhatsApp});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tag pill
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.15),
              border: Border.all(
                  color: AppColors.green.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Text(
              '✦ Now Open in Your Area',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppColors.green),
            ),
          ),
          const SizedBox(height: 20),

          // Headline
          RichText(
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textLight,
                  height: 1.2),
              children: [
                TextSpan(text: 'Grow Your Business '),
                TextSpan(
                    text: 'Smarter',
                    style: TextStyle(color: AppColors.green)),
                TextSpan(text: ', Not Harder'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Subtext
          const Text(
            'We help local businesses attract more customers, manage leads, and deliver exceptional service — all in one simple system.',
            style: TextStyle(
                fontSize: 15,
                color: AppColors.textMuted,
                height: 1.6),
          ),
          const SizedBox(height: 28),

          // CTA Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Text('🚀',
                      style: TextStyle(fontSize: 16)),
                  label: const Text('Get Demo',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onWhatsApp,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.white,
                    side: const BorderSide(
                        color: AppColors.border, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Text('💬',
                      style: TextStyle(fontSize: 16)),
                  label: const Text('WhatsApp',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Stat cards grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.8,
            children: const [
              _StatCard(num: '340+', desc: 'Happy Clients'),
              _StatCard(num: '98%', desc: 'Satisfaction Rate'),
              _StatCard(num: '24/7', desc: 'Support Available'),
              _StatCard(num: '5★', desc: 'Average Rating'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String num;
  final String desc;
  const _StatCard({required this.num, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bg2.withOpacity(0.5),
        border: Border.all(color: AppColors.borderSoft),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(num,
              style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.green)),
          const SizedBox(height: 4),
          Text(desc,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textDim)),
        ],
      ),
    );
  }
}

// ── ABOUT ─────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  const _AboutSection();

  static const List<String> _pills = [
    'Lead capture & follow-up',
    'Instant chatbot support',
    'Business analytics dashboard',
    'Mobile-ready Flutter app',
    'WhatsApp integration',
    'Simple, no database required',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(text: 'About LocalBiz'),
          const SizedBox(height: 8),
          const Text(
            'Built for Small Businesses That Want Real Results',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textLight,
                height: 1.2),
          ),
          const SizedBox(height: 12),
          const Text(
            'We understand the challenges local businesses face. That\'s why we built a lightweight, fast system that handles customer inquiries, captures leads, and keeps you connected — without the complexity of enterprise software.',
            style: TextStyle(
                fontSize: 15,
                color: AppColors.textMuted,
                height: 1.65),
          ),
          const SizedBox(height: 24),

          // Pills
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0d1e1c),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.borderSoft),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _pills
                  .map((p) => _Pill(text: p))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.green.withOpacity(0.12),
        border: Border.all(
            color: AppColors.green.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.mint)),
        ],
      ),
    );
  }
}

// ── SERVICES ──────────────────────────────────────────────
class _ServicesSection extends StatelessWidget {
  const _ServicesSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg3,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(text: 'What We Offer'),
          const SizedBox(height: 8),
          const Text(
            'Our Services',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textLight,
                height: 1.2),
          ),
          const SizedBox(height: 8),
          const Text(
            'Everything you need to run a modern local business, simplified.',
            style: TextStyle(
                fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(height: 28),
          const _ServiceCard(
            icon: '💬',
            title: 'AI Chatbot Support',
            items: [
              'Instant automated responses',
              '24/7 availability',
              'Handles common FAQs',
              'Chat log analytics',
            ],
          ),
          const SizedBox(height: 16),
          const _ServiceCard(
            icon: '📋',
            title: 'Lead Management',
            items: [
              'Contact form integration',
              'CSV-based lead storage',
              'Email capture & tracking',
              'Follow-up reminders',
            ],
          ),
          const SizedBox(height: 16),
          const _ServiceCard(
            icon: '📊',
            title: 'Business Analytics',
            items: [
              'Total leads counter',
              'Most common queries',
              'Chat volume tracking',
              'Exportable reports',
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String icon;
  final String title;
  final List<String> items;
  const _ServiceCard(
      {required this.icon,
      required this.title,
      required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0f2420),
        border: Border.all(
            color: AppColors.green.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(icon,
                  style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(height: 14),
          Text(title,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textLight)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text('→ ',
                        style: TextStyle(
                            color: AppColors.green,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    Expanded(
                      child: Text(item,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textMuted)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── HOW IT WORKS ──────────────────────────────────────────
class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 48),
      child: Column(
        children: [
          _SectionLabel(text: 'The Process'),
          const SizedBox(height: 8),
          const Text(
            'How It Works in 3 Steps',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.textLight,
                height: 1.2),
          ),
          const SizedBox(height: 36),
          const _StepItem(
            number: '1',
            title: 'You Sign Up',
            description:
                'Fill out the contact form. We\'ll get back to you within 24 hours to discuss your needs and set up your account.',
          ),
          const SizedBox(height: 16),
          const _StepItem(
            number: '2',
            title: 'We Configure',
            description:
                'We deploy your chatbot, set up your lead capture system, and connect everything to your mobile app — no technical knowledge needed.',
          ),
          const SizedBox(height: 16),
          const _StepItem(
            number: '3',
            title: 'You Grow',
            description:
                'Start receiving leads, answering customer queries automatically, and tracking your business performance from day one.',
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  const _StepItem(
      {required this.number,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bg2.withOpacity(0.3),
        border: Border.all(color: AppColors.borderSoft),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number circle
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(number,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight)),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared: Section Label ──────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
          color: AppColors.green),
    );
  }
}
