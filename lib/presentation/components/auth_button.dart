import 'package:flutter/material.dart';
import '../../core/responsive_config.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onClick;

  const AuthButton({
    super.key,
    required this.text,
    this.enabled = true,
    this.isLoading = false,
    required this.onClick,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    // Ambient breathing shadow pulse
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Sweeping glass reflection
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      widget.onClick();
    }
  }

  void _handleTapCancel() {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = !widget.enabled || widget.isLoading;
    final radius =
        BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16));

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut, // Extremely satisfying bouncy scale
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _shimmerController]),
          builder: (context, child) {
            final pulse = _pulseController.value;
            final shimmer = _shimmerController.value;

            return Container(
              width: double.infinity,
              height: ResponsiveConfig.getProportionateScreenHeight(56),
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  colors: isDisabled
                      ? [const Color(0xFF3A2219), const Color(0xFF2A1510)]
                      : [
                          const Color(0xFFC07F00), // Rich Gold
                          const Color(0xFFFFD59A), // Light Gold
                          const Color(0xFFC07F00), // Rich Gold
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: isDisabled
                    ? []
                    : [
                        // Intense glowing shadow that expands on press
                        BoxShadow(
                          color: const Color(0xFFFFD59A)
                              .withOpacity(0.3 + (pulse * 0.3)),
                          blurRadius: _isPressed ? 25 : 15 + (pulse * 5),
                          spreadRadius: _isPressed ? 2 : 0,
                          offset: Offset(0, _isPressed ? 2 : 6),
                        ),
                        // Inner glow top edge
                        BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Sweeping diagonal shiny glass reflection
                  if (!isDisabled)
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
                                  Colors.white.withOpacity(0.6),
                                  Colors.white.withOpacity(0.0),
                                ],
                                stops: const [0.4, 0.5, 0.6],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Text and Icon logic
                  Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: widget.isLoading
                          ? SizedBox(
                              width:
                                  ResponsiveConfig.getProportionateScreenWidth(
                                      20),
                              height:
                                  ResponsiveConfig.getProportionateScreenWidth(
                                      20),
                              child: const CircularProgressIndicator(
                                color: Color(0xFF6B4200),
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.text,
                                  style: TextStyle(
                                    color: const Color(
                                        0xFF2A1510), // Deep contrasting dark brown
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                    fontSize: ResponsiveConfig.fontSize(16),
                                  ),
                                ),
                                SizedBox(
                                    width: ResponsiveConfig
                                        .getProportionateScreenWidth(8)),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: const Color(0xFF2A1510),
                                  size: ResponsiveConfig
                                      .getProportionateScreenWidth(20),
                                ),
                              ],
                            ),
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
