import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Placeholder para el logo, puedes cambiarlo por un Image.asset si tienes la imagen
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.real_estate_agent, // Icono similar a rentas
            color: AppColors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Rent',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        const Text(
          'Us',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: AppColors.primary,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
