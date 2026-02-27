import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final List<Color> colors;
  final List<Color> blobColors;
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.colors,
    required this.blobColors,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: _BackgroundBlobPainter(
                    phase: _animation.value,
                    blobColors: widget.blobColors,
                  ),
                );
              },
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _BackgroundBlobPainter extends CustomPainter {
  final double phase;
  final List<Color> blobColors;

  _BackgroundBlobPainter({required this.phase, required this.blobColors});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint1 = Paint()..color = blobColors[0];
    canvas.drawCircle(
      Offset(w * (0.24 + 0.06 * phase), h * (0.24 + 0.03 * phase)),
      w * 0.34,
      paint1,
    );

    if (blobColors.length > 1) {
      final paint2 = Paint()..color = blobColors[1];
      canvas.drawCircle(
        Offset(w * (0.8 - 0.08 * phase), h * (0.62 - 0.04 * phase)),
        w * 0.26,
        paint2,
      );
    }

    if (blobColors.length > 2) {
      final paint3 = Paint()..color = blobColors[2];
      canvas.drawCircle(
        Offset(w * (0.52 + 0.04 * phase), h * (0.84 - 0.02 * phase)),
        w * 0.18,
        paint3,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundBlobPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}
