import 'dart:async';
import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';
import 'app_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.initialItems});
  final List<ExpiryItem> initialItems;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    // Auto-navigate after 2.5 seconds, but allow user tap to proceed immediately
    _timer = Timer(const Duration(milliseconds: 2500), _navigateToApp);
  }

  void _navigateToApp() {
    if (!mounted) return;
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AppShell(initialItems: widget.initialItems),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: InkWell(
          onTap: _navigateToApp,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Playful Mascot Visual with Glowing Rings
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [kSoftGreen, kSoftYellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kDarkGreen.withValues(alpha: 0.18),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: const BoxDecoration(
                              color: kWhite,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '🐻🧺',
                                style: TextStyle(fontSize: 56),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: kSoftYellow,
                                shape: BoxShape.circle,
                              ),
                              child: const Text('✨',
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // App Title & Tagline with FadeTransition
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        const Text(
                          'ExpireMate',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                            color: kDarkGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Teman Pintar Pengingat Kedaluwarsa',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: kDarkText,
                            letterSpacing: -0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Jangan Lewatkan Tanggal Kedaluwarsa! 🌱',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: kSubText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Stylish CTA Button
                  FilledButton.icon(
                    onPressed: _navigateToApp,
                    style: FilledButton.styleFrom(
                      backgroundColor: kDarkGreen,
                      foregroundColor: kWhite,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 3,
                      shadowColor: kDarkGreen.withValues(alpha: 0.3),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                    label: const Text(
                      'Mulai Sekarang',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ketuk di mana saja untuk mulai',
                    style: TextStyle(
                      fontSize: 11,
                      color: kSubText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
