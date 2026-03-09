import 'package:flutter/material.dart';
import '../../core/responsive_config.dart';

class SocialButton extends StatefulWidget {
  final String text;
  final VoidCallback onClick;

  const SocialButton({
    super.key,
    required this.text,
    required this.onClick,
  });

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late final AnimationController _pulseController;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) =>
      setState(() => _isPressed = true);

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onClick();
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut, // Apple-style bouncy feeling
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _shimmerController]),
          builder: (context, child) {
            final pulse = _pulseController.value;
            final shimmer = _shimmerController.value;

            // Subtle pulsing border tone
            final borderTone = _isPressed
                ? const Color(0xFFFFD59A)
                : Color.lerp(
                    const Color(0x33FFFFFF), const Color(0x66FFFFFF), pulse)!;

            return Container(
              width: double.infinity,
              height: ResponsiveConfig.getProportionateScreenHeight(56),
              decoration: BoxDecoration(
                color: _isPressed
                    ? const Color(0x26FFFFFF) // Lightens up slightly on press
                    : const Color(0x12FFFFFF), // Base translucent dark
                borderRadius: BorderRadius.circular(
                    ResponsiveConfig.getProportionateScreenWidth(18)),
                border: Border.all(
                    color: borderTone, width: _isPressed ? 2.0 : 1.5),
                boxShadow: _isPressed
                    ? [
                        BoxShadow(
                            color: const Color(0xFFFFD59A).withOpacity(0.25),
                            blurRadius: 20,
                            spreadRadius: 2)
                      ]
                    : [],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Sophisticated glass sweeps over the button
                  Positioned.fill(
                    child: FractionallySizedBox(
                      widthFactor: 2.0,
                      alignment: Alignment(-1.5 + (shimmer * 3.0), 0),
                      child: Transform.rotate(
                        angle: -0.3,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.08),
                                Colors.white.withOpacity(0.0),
                              ],
                              stops: const [0.4, 0.5, 0.6],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Texts and Icon overlay
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width:
                              ResponsiveConfig.getProportionateScreenWidth(22),
                          height:
                              ResponsiveConfig.getProportionateScreenWidth(22),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                                0xFF15100E), // Pure dark fill inside G circle
                            border: Border.fromBorderSide(
                              BorderSide(
                                  color: _isPressed
                                      ? const Color(0xFFFFD59A)
                                      : const Color(0x66FFFFFF),
                                  width: 1.5),
                            ),
                            boxShadow: _isPressed
                                ? [
                                    BoxShadow(
                                        color: const Color(0xFFFFD59A)
                                            .withOpacity(0.5),
                                        blurRadius: 8)
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              'G',
                              style: TextStyle(
                                color: _isPressed
                                    ? const Color(0xFFFFD59A)
                                    : Colors.white,
                                fontSize: ResponsiveConfig.fontSize(13),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: ResponsiveConfig.getProportionateScreenWidth(
                                12)),
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            fontSize: ResponsiveConfig.fontSize(15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
