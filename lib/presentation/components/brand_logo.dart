import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';
import '../../core/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: ResponsiveConfig.getProportionateScreenWidth(40),
          height: ResponsiveConfig.getProportionateScreenWidth(40),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
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
            fontWeight: FontWeight.w800,
            fontSize: ResponsiveConfig.fontSize(30),
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          'Us',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: ResponsiveConfig.fontSize(30),
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
