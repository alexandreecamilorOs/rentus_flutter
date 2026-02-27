import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';
import '../../core/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: ResponsiveConfig.getProportionateScreenWidth(42),
          height: ResponsiveConfig.getProportionateScreenWidth(42),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFFFE39A), AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xAA4D2F24),
                blurRadius: ResponsiveConfig.getProportionateScreenWidth(18),
                offset: Offset(0, ResponsiveConfig.getProportionateScreenHeight(8)),
              ),
            ],
          ),
          child: Icon(
            Icons.real_estate_agent,
            color: AppColors.white,
            size: ResponsiveConfig.getProportionateScreenWidth(24),
          ),
        ),
        SizedBox(width: ResponsiveConfig.getProportionateScreenWidth(8)),
        Text(
          'Rent',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: ResponsiveConfig.fontSize(30),
            letterSpacing: -0.6,
            color: Colors.white,
          ),
        ),
        Text(
          'Us',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: ResponsiveConfig.fontSize(30),
            letterSpacing: -0.6,
            color: const Color(0xFFFFD672),
          ),
        ),
      ],
    );
  }
}
