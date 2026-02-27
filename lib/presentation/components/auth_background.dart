import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../animations/animated_background.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      colors: const [
        AppColors.background,
        AppColors.accent,
        Color(0xFFB8A890),
      ],
      blobColors: [
        AppColors.white.withOpacity(0.13),
        AppColors.primary.withOpacity(0.12),
        const Color(0xFFDA9C5F).withOpacity(0.1),
      ],
      child: child,
    );
  }
}
