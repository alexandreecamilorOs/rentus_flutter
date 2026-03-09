import 'package:flutter/material.dart';

class UpwardParticles extends StatefulWidget {
  final int particleCount;
  const UpwardParticles({super.key, this.particleCount = 50});

  @override
  State<UpwardParticles> createState() => _UpwardParticlesState();
}

class _UpwardParticlesState extends State<UpwardParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
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
        return CustomPaint(
          painter: _ParticlesPainter(
            phase: _controller.value,
            particleCount: widget.particleCount,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double phase;
  final int particleCount;

  _ParticlesPainter({
    required this.phase,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < particleCount; i++) {
      double x = (i * 137) % w;
      double yBase = ((i * 251) % h);
      double y = (yBase - phase * h) % h;
      if (y < 0) y += h;

      paint.color =
          i % 2 == 0 ? const Color(0x33DA9C5F) : Colors.white.withOpacity(0.08);

      canvas.drawCircle(Offset(x, y), 1.0 + (i % 3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.particleCount != particleCount;
}
