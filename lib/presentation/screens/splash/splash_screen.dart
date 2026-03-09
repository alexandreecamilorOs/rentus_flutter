import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/router/app_router.dart';
import '../../../data/providers/auth_provider.dart';
import '../../components/brand_logo.dart';
import '../../components/upward_particles.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  Future<void> _startTransition() async {
    // Artificial delay to show the beautiful, top-premium splash animation
    await Future.delayed(const Duration(milliseconds: 3200));

    if (!mounted) return;

    // Trigger the graceful fade-out exit
    setState(() {
      _isExiting = true;
    });

    // Wait for the fade-out to complete before navigating
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Determine target route based on authentication state
    final authState = ref.read(authProvider);
    final targetRoute =
        authState.isAuthenticated ? AppRoutes.home : AppRoutes.login;

    // Navigate smoothly
    context.go(targetRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A09),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 800),
        opacity: _isExiting ? 0.0 : 1.0,
        curve: Curves.easeInOutCubic,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Unified Cinematic Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D0A09),
                    Color(0xFF1E1410),
                    Color(0xFF2E1D17),
                  ],
                ),
              ),
            ),

            // 2. Cinematic upward particles (Staggered elegant entrance)
            const UpwardParticles()
                .animate()
                .fadeIn(delay: 400.ms, duration: 2000.ms, curve: Curves.easeIn),

            // 3. Background Orbs for depth
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDA9C5F).withOpacity(0.08),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 2000.ms),
            ),

            // 4. Centered Premium Logo (Majestic Entrance + Breathing Pulse)
            Center(
              child: Transform.scale(
                scale: 1.5, // Make the logo much larger for the splash screen
                child: const BrandLogo(),
              )
                  .animate()
                  .fadeIn(duration: 1500.ms, curve: Curves.easeOutCubic)
                  .scaleXY(
                      begin: 0.85,
                      end: 1.0,
                      duration: 1500.ms,
                      curve: Curves.easeOutBack)
                  .then() // After entrance, start a subtle breathing effect
                  .animate(
                      onPlay: (controller) => controller.repeat(reverse: true))
                  .scaleXY(
                      begin: 1.0,
                      end: 1.03,
                      duration: 3.seconds,
                      curve: Curves.easeInOutSine),
            ),

            // 5. Sleek, ultra-thin premium loading line instead of a basic spinner
            Positioned(
              bottom: 60,
              left: MediaQuery.of(context).size.width * 0.25,
              right: MediaQuery.of(context).size.width * 0.25,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 1.5, // Ultra thin and elegant
                  color: Colors.white.withOpacity(0.05), // Faint track
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFDA9C5F), // Accent color
                          Color(0xFFFAE8D1), // Bright shimmer
                          Color(0xFFDA9C5F),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDA9C5F).withOpacity(0.5),
                          blurRadius: 10,
                        )
                      ],
                    ),
                  ).animate().custom(
                        duration: 2800.ms, // Finishes right before exit
                        curve: Curves.easeInOutCubic,
                        builder: (context, value, child) {
                          return FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: value, // Animates from 0.0 to 1.0
                            child: child,
                          );
                        },
                      ),
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 1000.ms),
            ),
          ],
        ),
      ),
    );
  }
}
