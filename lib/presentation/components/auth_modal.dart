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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.getProportionateScreenWidth(32),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD59A).withOpacity(0.08),
            blurRadius: 40,
            spreadRadius: -10,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: ResponsiveConfig.getProportionateScreenWidth(24),
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          ResponsiveConfig.getProportionateScreenWidth(32),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x9915100E), // Ultra Premium Dark
              border: Border.all(color: const Color(0x33FFD59A), width: 1.5),
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.getProportionateScreenWidth(32),
              ),
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
