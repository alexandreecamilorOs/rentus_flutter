import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuthTabRow extends StatelessWidget {
  final bool isLoginSelected;
  final VoidCallback onLoginClick;
  final VoidCallback onRegisterClick;

  const AuthTabRow({
    super.key,
    required this.isLoginSelected,
    required this.onLoginClick,
    required this.onRegisterClick,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final tabWidth =
            (totalWidth - 8) / 2; // -8 por el padding (4 a cada lado)

        return Container(
          width: double.infinity,
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: isLoginSelected ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onLoginClick,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: isLoginSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onRegisterClick,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: Text(
                          'Registrarse',
                          style: TextStyle(
                            color: !isLoginSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
