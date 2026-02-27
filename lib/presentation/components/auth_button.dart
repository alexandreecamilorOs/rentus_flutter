import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';
import '../../core/theme/app_colors.dart';
import 'luxury_wave_overlay.dart';

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

class _AuthButtonState extends State<AuthButton>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _waveController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: false);
    _glowAnimation = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.fastOutSlowIn),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    _waveController.dispose();
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
    final radius = BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16));

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          width: double.infinity,
          height: ResponsiveConfig.getProportionateScreenHeight(56),
          decoration: BoxDecoration(
            borderRadius: radius,
            color: isDisabled ? AppColors.primaryDark.withOpacity(0.4) : null,
            boxShadow: [
              BoxShadow(
                color: const Color(0x663A2219),
                blurRadius: ResponsiveConfig.getProportionateScreenWidth(26),
                offset: Offset(0, ResponsiveConfig.getProportionateScreenHeight(10)),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              if (!isDisabled)
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: const [
                            AppColors.primaryDark,
                            AppColors.primary,
                            Color(0xFF7D512E),
                            AppColors.primaryDark,
                          ],
                          stops: [
                            0,
                            (_glowAnimation.value - 0.2).clamp(0.0, 1.0),
                            _glowAnimation.value.clamp(0.0, 1.0),
                            (_glowAnimation.value + 0.2).clamp(0.0, 1.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              Positioned.fill(
                child: LuxuryWaveOverlay(
                  animation: _waveController,
                  color: const Color(0xFFFFD59A),
                ),
              ),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: widget.isLoading
                      ? SizedBox(
                          width: ResponsiveConfig.getProportionateScreenWidth(18),
                          height: ResponsiveConfig.getProportionateScreenWidth(18),
                          child: const CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.text,
                              style: TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.7,
                                fontSize: ResponsiveConfig.fontSize(16),
                              ),
                            ),
                            SizedBox(width: ResponsiveConfig.getProportionateScreenWidth(6)),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.white,
                              size: ResponsiveConfig.getProportionateScreenWidth(20),
                            ),
                          ],
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
