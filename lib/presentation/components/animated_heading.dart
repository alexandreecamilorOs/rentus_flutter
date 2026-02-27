import 'package:flutter/material.dart';

class AnimatedHeading extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final List<Color> gradientColors;
  final int durationMillis;

  const AnimatedHeading({
    super.key,
    required this.text,
    required this.style,
    this.textAlign,
    this.gradientColors = const [
      Color(0xFF2E1D17),
      Color(0xFF8A5D34),
      Color(0xFFDA9C5F)
    ],
    this.durationMillis = 2200,
  });

  @override
  State<AnimatedHeading> createState() => _AnimatedHeadingState();
}

class _AnimatedHeadingState extends State<AnimatedHeading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.durationMillis),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: widget.gradientColors,
              transform: _HeadingGradientTransform(_animation.value),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: Text(
            widget.text,
            textAlign: widget.textAlign,
            style: widget.style.copyWith(fontWeight: FontWeight.w800),
          ),
        );
      },
    );
  }
}

class _HeadingGradientTransform extends GradientTransform {
  const _HeadingGradientTransform(this.slidePercent);

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
