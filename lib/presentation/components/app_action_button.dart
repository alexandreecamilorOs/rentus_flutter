import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';

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
      Color(0xFF2A1B5F),
      Color(0xFF6B3FC9),
      Color(0xFF16B8C9),
      Color(0xFF9D7BFF)
    ],
    this.paddingValues = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.animationSeed = 101,
  });

  @override
  State<AppActionButton> createState() => _AppActionButtonState();
}

class _AppActionButtonState extends State<AppActionButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
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
    ResponsiveConfig.init(context);
    final scale = _isPressed ? 0.98 : 1.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16)),
        splashColor: Colors.white.withOpacity(0.25),
        highlightColor: Colors.white.withOpacity(0.08),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            height: ResponsiveConfig.getProportionateScreenHeight(52),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16)),
              gradient: LinearGradient(
                colors: widget.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _BubblePainter(
                          phase: _controller.value,
                          seed: widget.animationSeed,
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: widget.paddingValues,
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: widget.contentColor,
                        fontSize: ResponsiveConfig.fontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

      final alpha = (0.08 + rand.nextDouble() * 0.35).clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(alpha);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
