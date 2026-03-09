import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/responsive_config.dart';
import 'brand_logo.dart';
import 'language_toggle.dart';

class ModernHeader extends StatefulWidget {
  final VoidCallback onMenuPressed;
  final bool isDrawerOpen;

  const ModernHeader({
    super.key,
    required this.onMenuPressed,
    this.isDrawerOpen = false,
  });

  @override
  State<ModernHeader> createState() => _ModernHeaderState();
}

class _ModernHeaderState extends State<ModernHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(
          seconds: 8), // Faster for a more noticeable "cool" effect
    )..repeat(); // Continuous forward loop
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        // Calculate dynamic positions for the aurora flares
        // Use math.sin/cos locally, we'll need to make sure 'dart:math' is imported. Wait, this file might not have it. Let's use simple linear movement first or we'll add math import if needed.
        // Actually, let's just use the controller value to sweep gradients.
        final slide1 = _bgController.value * 2.0;

        return Container(
          height: 80, // Premium height
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: const Color(0xFF15100E).withOpacity(
                    0.95), // Ultra dark base that fixes the white background
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Dynamic Aurora Layer 1 (Sweeping Accent Color)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(slide1 - 1.5, -1),
                            end: Alignment(slide1 - 0.5, 1),
                            colors: [
                              Colors.transparent,
                              const Color(0xFFDA9C5F)
                                  .withOpacity(0.15), // Subtle gold flare
                              const Color(0xFFDA9C5F)
                                  .withOpacity(0.35), // Brighter core
                              const Color(0xFFDA9C5F).withOpacity(0.15),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Dynamic Aurora Layer 2 (Counter-sweeping highlight)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(1.5 - slide1, 1),
                            end: Alignment(0.5 - slide1, -1),
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.05),
                              Colors.white
                                  .withOpacity(0.15), // Sharp white light
                              Colors.white.withOpacity(0.05),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.45, 0.5, 0.55, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Content Container with bottom border
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            ResponsiveConfig.adaptiveSpacing(mobile: 20),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFFDA9C5F)
                                .withOpacity(0.25), // Stronger base definition
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: SafeArea(
                        bottom: false,
                        child: Row(
                          children: [
                            // Hamburger Menu Left
                            _HamburgerButton(
                              onTap: widget.onMenuPressed,
                              isOpen: widget.isDrawerOpen,
                            ),

                            SizedBox(
                                width: ResponsiveConfig.adaptiveSpacing(
                                    mobile: 15)),

                            // Logo (The focal point of animation)
                            const BrandLogo(),

                            const Spacer(),

                            // Header Right: Only Premium Language Toggle
                            const LanguageToggle(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HamburgerButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isOpen;

  const _HamburgerButton({required this.onTap, this.isOpen = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isOpen ? 25 : 28,
              height: 2.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              transform: isOpen
                  ? (Matrix4.translationValues(0, 0, 0)
                    ..rotateZ(45 * 3.14159 / 180))
                  : Matrix4.identity(),
            ),
            const SizedBox(height: 5),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isOpen ? 0 : 1,
              child: Container(
                width: 22,
                height: 2.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 5),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isOpen ? 25 : 18,
              height: 2.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              transform: isOpen
                  ? (Matrix4.translationValues(0, -15, 0)
                    ..rotateZ(-45 * 3.14159 / 180))
                  : Matrix4.identity(),
            ),
          ],
        ),
      ),
    );
  }
}
