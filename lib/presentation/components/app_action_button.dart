import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';
import 'luxury_wave_overlay.dart';

class AppActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onClick;
  final Color contentColor;
  final List<Color> gradient;
  final EdgeInsets paddingValues;
  final int animationSeed;

  const AppActionButton({
    super.key,
    required this.text,
    required this.onClick,
    this.contentColor = Colors.white,
    this.gradient = const [
      Color(0xFF3B251D),
      Color(0xFF8A5D34),
      Color(0xFFC9915C),
      Color(0xFFDEA46E)
    ],
    this.paddingValues = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.animationSeed = 101,
  });

  @override
  State<AppActionButton> createState() => _AppActionButtonState();
}

class _AppActionButtonState extends State<AppActionButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _bubbleController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1450),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bubbleController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) => setState(() => _isPressed = true);

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onClick();
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16));

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 130),
        child: Container(
          width: double.infinity,
          height: ResponsiveConfig.getProportionateScreenHeight(52),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              colors: widget.gradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xAA8A5D34).withOpacity(0.28),
                blurRadius: ResponsiveConfig.getProportionateScreenWidth(28),
                offset: Offset(0, ResponsiveConfig.getProportionateScreenHeight(12)),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _bubbleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _BubblePainter(
                        phase: _bubbleController.value,
                        seed: widget.animationSeed,
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: LuxuryWaveOverlay(
                  animation: _waveController,
                  color: const Color(0xFFFFD59A),
                ),
              ),
              Center(
                child: Padding(
                  padding: widget.paddingValues,
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: widget.contentColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                      fontSize: ResponsiveConfig.fontSize(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubblePainter extends CustomPainter {
  final double phase;
  final int seed;

  _BubblePainter({required this.phase, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rand = math.Random(seed);

    for (int i = 0; i < 20; i++) {
      final originX = rand.nextDouble() * size.width;
      final originY = rand.nextDouble() * size.height;
      final radius = 1.0 + rand.nextDouble() * 2.5;
      final speedX = (rand.nextDouble() - 0.5) * 40;
      final speedY = (rand.nextDouble() - 0.5) * 20;
      final x = (originX + phase * speedX) % size.width;
      final y = (originY + phase * speedY) % size.height;

      paint.color = Colors.white.withOpacity((0.08 + rand.nextDouble() * 0.35).clamp(0.0, 1.0));
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) => oldDelegate.phase != phase;
}
