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

class _SocialButtonState extends State<SocialButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onClick();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          height: ResponsiveConfig.getProportionateScreenHeight(54),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16)),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    final center = (_waveController.value * 1.4) - 0.2;
                    final leftStop = (center - 0.28).clamp(0.0, 1.0);
                    final middleStop = center.clamp(0.0, 1.0);
                    final rightStop = (center + 0.28).clamp(0.0, 1.0);

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: const [
                            Colors.transparent,
                            Color(0xAAFFD84D),
                            Colors.transparent,
                          ],
                          stops: [leftStop, middleStop, rightStop],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Row(
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
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveConfig.fontSize(14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
