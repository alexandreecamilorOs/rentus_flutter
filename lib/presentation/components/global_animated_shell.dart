import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Capa global animada para todas las vistas.
///
/// - Mantiene la paleta existente.
/// - Añade movimiento suave (glows + partículas).
/// - Aplica responsive global (padding, maxWidth y adaptación para tablet).
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
      duration: const Duration(seconds: 11),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isSmallMobile = width < 360;
        final isTablet = width >= 600;
        final horizontalPadding =
            isSmallMobile ? 8.0 : (isTablet ? 20.0 : 12.0);
        final maxContentWidth = width >= 1200
            ? 1080.0
            : width >= 900
                ? 860.0
                : width >= 600
                    ? 720.0
                    : width;

        final isProfile = widget.child.toString().contains('ProfileScreen');

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = Curves.easeInOutCubic.transform(_controller.value);

            return Stack(
              fit: StackFit.expand,
              children: [
                IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-1 + (t * 0.6), -1),
                        end: Alignment(1, 1 - (t * 0.45)),
                        colors: const [
                          Color(0x2ADA9C5F),
                          Color(0x1A8A5D34),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.58, 1.0],
                      ),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: CustomPaint(
                    painter: _GlobalParticlesPainter(phase: _controller.value),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: isProfile
                          ? widget.child
                          : TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 420),
                              tween: Tween(begin: 0.985, end: 1.0),
                              curve: Curves.easeOutCubic,
                              builder: (context, scale, child) =>
                                  Transform.scale(
                                scale: scale,
                                child: child,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 380),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                child: KeyedSubtree(
                                  key: ValueKey<String>(
                                      widget.child.runtimeType.toString()),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        isTablet ? 22 : 0),
                                    child: widget.child,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
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

    for (int i = 0; i < 28; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final driftX = (random.nextDouble() - 0.5) * 62;
      final driftY = (random.nextDouble() - 0.5) * 36;
      final radius = 1.1 + random.nextDouble() * 3.8;

      final x = (baseX + (phase * driftX)) % size.width;
      final y = (baseY + (phase * driftY)) % size.height;

      paint.color =
          i.isEven ? const Color(0x26F4E5D6) : const Color(0x26FFD59A);

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GlobalParticlesPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
