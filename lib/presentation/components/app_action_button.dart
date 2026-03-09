import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/animations/rentus_physics.dart';
import '../../core/responsive_config.dart';

class AppActionButton extends StatefulWidget {
  final String text;
  final VoidCallback onClick;
  final Color contentColor;
  final List<Color> gradient;
  final EdgeInsets paddingValues;
  final int animationSeed;
  final bool isSecondary;
  final Color? borderColor;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool isEnabled;

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
    this.paddingValues =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.animationSeed = 101,
    this.isSecondary = false,
    this.borderColor,
    this.icon,
    this.width,
    this.height,
    this.isEnabled = true,
  });

  @override
  State<AppActionButton> createState() => _AppActionButtonState();
}

class _AppActionButtonState extends State<AppActionButton>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  Offset _rippleOrigin = const Offset(0.5, 0.5);

  late final AnimationController _floatController;
  late final AnimationController _scaleController;
  late final AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _scaleController = AnimationController.unbounded(
      vsync: this,
      value: 1,
    );

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _scaleController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  Offset _resolveTouchOrigin(Offset globalPosition) {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return const Offset(0.5, 0.5);
    }

    final local = renderObject.globalToLocal(globalPosition);
    final dx = (local.dx / renderObject.size.width).clamp(0.0, 1.0).toDouble();
    final dy = (local.dy / renderObject.size.height).clamp(0.0, 1.0).toDouble();
    return Offset(dx, dy);
  }

  void _animateScale({
    required double target,
    required SpringDescription spring,
    double velocity = 0,
  }) {
    _scaleController.animateWith(
      RentusPhysics.simulation(
        spring: spring,
        from: _scaleController.value,
        to: target,
        velocity: velocity,
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isEnabled) {
      return;
    }

    setState(() {
      _isPressed = true;
      _rippleOrigin = _resolveTouchOrigin(details.globalPosition);
    });

    _animateScale(
      target: 0.92,
      spring: RentusPhysics.buttonPress,
      velocity: -2.1,
    );
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.isEnabled) {
      return;
    }

    setState(() {
      _isPressed = false;
      _rippleOrigin = _resolveTouchOrigin(details.globalPosition);
    });

    _rippleController.forward(from: 0);
    _animateScale(
      target: 1,
      spring: RentusPhysics.buttonRelease,
      velocity: 3.0,
    );
    widget.onClick();
  }

  void _handleTapCancel() {
    if (!widget.isEnabled) {
      return;
    }

    setState(() => _isPressed = false);
    _animateScale(
      target: 1,
      spring: RentusPhysics.buttonRelease,
      velocity: 1.6,
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius =
        BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16));
    final buttonHeight =
        widget.height ?? ResponsiveConfig.getProportionateScreenHeight(52);

    final animatedButton = AnimatedBuilder(
      animation: Listenable.merge([
        _floatController,
        _scaleController,
        _rippleController,
      ]),
      builder: (context, child) {
        final breathing = math.sin(_floatController.value * math.pi * 2);
        final lift = breathing * 1.6;
        final scale = _scaleController.value.clamp(0.88, 1.08).toDouble();
        final glowOpacity =
            (0.2 + (0.2 * ((breathing * 0.5) + 0.5))).clamp(0.2, 0.4);

        return Transform.translate(
          offset: Offset(0, -lift),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: widget.width ?? double.infinity,
              height: buttonHeight,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDA9C5F).withValues(
                      alpha: widget.isSecondary
                          ? (glowOpacity * 0.5).toDouble()
                          : glowOpacity.toDouble(),
                    ),
                    blurRadius: ResponsiveConfig.getProportionateScreenWidth(
                      widget.isSecondary ? 18 : 28,
                    ),
                    spreadRadius: ResponsiveConfig.getProportionateScreenWidth(
                      widget.isSecondary ? 0.6 : 1.4,
                    ),
                    offset: Offset(
                      0,
                      ResponsiveConfig.getProportionateScreenHeight(
                        widget.isSecondary ? 7 : 10,
                      ),
                    ),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.isSecondary
                              ? const [
                                  Color(0x222E1D17),
                                  Color(0x223B251D),
                                  Color(0x334D2F24),
                                ]
                              : widget.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: ColoredBox(
                        color: Colors.white.withValues(
                          alpha: widget.isSecondary ? 0.09 : 0.05,
                        ),
                      ),
                    ),
                    CustomPaint(
                      painter: _ButtonSheenPainter(
                        phase: _floatController.value,
                        seed: widget.animationSeed,
                        tint: const Color(0xFFC8A97E),
                      ),
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        painter: _TapRipplePainter(
                          progress: _rippleController.value,
                          origin: _rippleOrigin,
                          color: const Color(0xFFC8A97E),
                        ),
                      ),
                    ),
                    if (widget.isSecondary || widget.borderColor != null)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          border: Border.all(
                            color: widget.borderColor ??
                                const Color(0xFFDA9C5F).withValues(alpha: 0.3),
                            width: 1.1,
                          ),
                        ),
                      ),
                    Center(
                      child: Padding(
                        padding: widget.paddingValues,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.icon != null) ...[
                              Icon(
                                widget.icon,
                                color: widget.contentColor,
                                size: ResponsiveConfig
                                    .getProportionateScreenWidth(
                                  20,
                                ),
                              ),
                              SizedBox(
                                width: ResponsiveConfig
                                    .getProportionateScreenWidth(
                                  8,
                                ),
                              ),
                            ],
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: widget.contentColor,
                                fontWeight: FontWeight.w800,
                                letterSpacing: _isPressed ? 0.55 : 0.72,
                                fontSize: ResponsiveConfig.fontSize(16),
                              ),
                            ),
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

    return GestureDetector(
      onTapDown: widget.isEnabled ? _handleTapDown : null,
      onTapUp: widget.isEnabled ? _handleTapUp : null,
      onTapCancel: widget.isEnabled ? _handleTapCancel : null,
      child: Opacity(
        opacity: widget.isEnabled ? 1 : 0.45,
        child: animatedButton,
      ),
    ).animate().fade(duration: 360.ms, curve: RentusPhysics.settleCurve).slideY(
          begin: 0.16,
          end: 0,
          duration: 560.ms,
          curve: RentusPhysics.settleCurve,
        );
  }
}

class _ButtonSheenPainter extends CustomPainter {
  final double phase;
  final int seed;
  final Color tint;

  _ButtonSheenPainter({
    required this.phase,
    required this.seed,
    required this.tint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sweepCenter = ((phase * 1.7) - 0.35) * size.width;
    final sweepRect = Rect.fromLTWH(
      sweepCenter - (size.width * 0.35),
      0,
      size.width * 0.7,
      size.height,
    );

    final sweepPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          tint.withValues(alpha: 0.04),
          tint.withValues(alpha: 0.16),
          tint.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0, 0.2, 0.5, 0.78, 1],
      ).createShader(sweepRect);

    canvas.drawRect(sweepRect, sweepPaint);

    final random = math.Random(seed);
    for (int i = 0; i < 14; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final radius = 0.8 + (random.nextDouble() * 2.6);
      final wobbleX = math.sin((phase * math.pi * 2) + (i * 0.9)) * 8;
      final wobbleY = math.cos((phase * math.pi * 2) + (i * 1.3)) * 4;

      final sparkPaint = Paint()
        ..color = tint.withValues(alpha: 0.05 + (random.nextDouble() * 0.12));

      canvas.drawCircle(
        Offset(baseX + wobbleX, baseY + wobbleY),
        radius,
        sparkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ButtonSheenPainter oldDelegate) {
    return oldDelegate.phase != phase ||
        oldDelegate.seed != seed ||
        oldDelegate.tint != tint;
  }
}

class _TapRipplePainter extends CustomPainter {
  final double progress;
  final Offset origin;
  final Color color;

  _TapRipplePainter({
    required this.progress,
    required this.origin,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) {
      return;
    }

    final eased = Curves.easeOutCubic.transform(progress);
    final maxRadius = math.sqrt(
      (size.width * size.width) + (size.height * size.height),
    );
    final radius = maxRadius * eased;
    final center = Offset(origin.dx * size.width, origin.dy * size.height);
    final fade = (1 - progress).clamp(0.0, 1.0);

    final ripplePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: (0.42 * fade).clamp(0.0, 1.0)),
          color.withValues(alpha: (0.1 * fade).clamp(0.0, 1.0)),
          Colors.transparent,
        ],
        stops: const [0, 0.56, 1],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, ripplePaint);
  }

  @override
  bool shouldRepaint(covariant _TapRipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.origin != origin ||
        oldDelegate.color != color;
  }
}
