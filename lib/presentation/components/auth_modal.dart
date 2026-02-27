import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';

class AuthModal extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const AuthModal({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(24)),
            border: Border.all(color: Colors.white.withOpacity(0.35)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: ResponsiveConfig.getProportionateScreenWidth(32),
                offset: Offset(0, ResponsiveConfig.getProportionateScreenHeight(14)),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
