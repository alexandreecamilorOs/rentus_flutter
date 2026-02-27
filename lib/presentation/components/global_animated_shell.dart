import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Capa global animada para todas las vistas.
///
/// Mantiene los colores base de cada pantalla y solo añade movimiento sutil
/// (glows, degradados y partículas) para un look más llamativo sin romper
/// la UI existente.
class GlobalAnimatedShell extends StatefulWidget {
  final Widget child;

  const GlobalAnimatedShell({super.key, required this.child});

  @override
  State<GlobalAnimatedShell> createState() => _GlobalAnimatedShellState();
}

class _GlobalAnimatedShellState extends State<GlobalAnimatedShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
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
      builder: (context, _) {
        final t = Curves.easeInOutCubic.transform(_controller.value);

        return Stack(
          fit: StackFit.expand,
          children: [
            // Overlay global con gradiente muy sutil para no invadir colores base.
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-1 + (t * 0.5), -1),
                    end: Alignment(1, 1 - (t * 0.4)),
                    colors: [
                      const Color(0x22DA9C5F),
                      const Color(0x1116B8C9),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),
            IgnorePointer(
              child: CustomPaint(
                painter: _GlobalParticlesPainter(phase: _controller.value),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 380),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey<String>(widget.child.runtimeType.toString()),
                child: widget.child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlobalParticlesPainter extends CustomPainter {
  final double phase;

  _GlobalParticlesPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(37);

    for (int i = 0; i < 22; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final driftX = (random.nextDouble() - 0.5) * 52;
      final driftY = (random.nextDouble() - 0.5) * 30;
      final radius = 1.2 + random.nextDouble() * 3.6;

      final x = (baseX + (phase * driftX)) % size.width;
      final y = (baseY + (phase * driftY)) % size.height;

      paint.color = i.isEven
          ? const Color(0x2EFFF3E4)
          : const Color(0x26FFD59A);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlobalParticlesPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
