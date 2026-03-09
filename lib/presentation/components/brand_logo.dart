import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/responsive_config.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Original Logo Icon (Sleek Entrance)
        Image.asset(
          'lib/core/theme/logo.png',
          height: ResponsiveConfig.getProportionateScreenWidth(38),
          fit: BoxFit.contain,
        )
            .animate()
            .fadeIn(duration: 1000.ms, curve: Curves.easeOutCubic)
            .scaleXY(
                begin: 0.8,
                end: 1.0,
                duration: 1000.ms,
                curve: Curves.easeOutBack),

        SizedBox(width: ResponsiveConfig.getProportionateScreenWidth(10)),

        // Ultra-Premium Animated Text
        const _PremiumAnimatedText(),
      ],
    );
  }
}

class _PremiumAnimatedText extends StatefulWidget {
  const _PremiumAnimatedText();

  @override
  State<_PremiumAnimatedText> createState() => _PremiumAnimatedTextState();
}

class _PremiumAnimatedTextState extends State<_PremiumAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Smooth, majestic loop
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Continuous right-to-left sweep for a sharp glint
        final sweepPhase = (_controller.value * 2) % 2.0 - 0.5;
        // Subtle vertical floating motion
        final floatOffset = math.sin(_controller.value * 2 * math.pi) * 2.0;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9), // Base "Rent" color
                  Colors.white.withOpacity(0.9),
                  Colors.white, // Intense shine core
                  const Color(0xFFDA9C5F), // Intense gold shine core
                  const Color(0xFFDA9C5F).withOpacity(0.9), // Base "Us" color
                  const Color(0xFFDA9C5F).withOpacity(0.9),
                ],
                stops: [
                  0.0,
                  sweepPhase - 0.1,
                  sweepPhase, // Peak white light
                  sweepPhase + 0.05, // Peak gold light transitioning
                  sweepPhase + 0.15,
                  1.0,
                ],
                begin: const Alignment(-1.5, -0.5),
                end: const Alignment(1.5, 0.5),
              ).createShader(bounds);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rent',
                  style: TextStyle(
                    fontSize: ResponsiveConfig.fontSize(32),
                    fontWeight: FontWeight.w900,
                    color: Colors.white, // Overridden by mask
                    letterSpacing: -1.0,
                  ),
                ),
                Text(
                  'Us',
                  style: TextStyle(
                    fontSize: ResponsiveConfig.fontSize(32),
                    fontWeight: FontWeight.w900,
                    color: Colors.white, // Overridden by mask
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate() // Add the majestic entrance on top of the continuous loop
            .fadeIn(delay: 300.ms, duration: 1000.ms, curve: Curves.easeOut)
            .slideX(
                begin: -0.1, end: 0, duration: 1000.ms, curve: Curves.easeOut);
      },
    );
  }
}
