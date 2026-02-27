import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';
import '../../core/theme/app_colors.dart';

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

class _SocialButtonState extends State<SocialButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) => setState(() => _isPressed = true);

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    widget.onClick();
  }

  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    final borderTone = _isPressed ? AppColors.border.withOpacity(0.65) : AppColors.border;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: double.infinity,
          height: ResponsiveConfig.getProportionateScreenHeight(54),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16)),
            border: Border.all(color: borderTone, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveConfig.getProportionateScreenWidth(18),
                height: ResponsiveConfig.getProportionateScreenWidth(18),
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent),
                child: Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveConfig.fontSize(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveConfig.getProportionateScreenWidth(8)),
              Text(
                widget.text,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: ResponsiveConfig.fontSize(14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
