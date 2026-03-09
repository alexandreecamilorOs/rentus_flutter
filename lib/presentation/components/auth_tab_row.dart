import 'package:flutter/material.dart';
import '../../core/responsive_config.dart';

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
        final tabWidth = (totalWidth - 10) / 2;

        return Container(
          width: double.infinity,
          height: ResponsiveConfig.getProportionateScreenHeight(54),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0x33000000), // Deep inset shadow track
            borderRadius: BorderRadius.circular(
                ResponsiveConfig.getProportionateScreenWidth(20)),
            border: Border.all(color: const Color(0x1AFFFFFF), width: 1),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                left: isLoginSelected ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE5A95D), Color(0xFFC78133)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                        ResponsiveConfig.getProportionateScreenWidth(16)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE5A95D).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
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
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: isLoginSelected
                                ? Colors.white
                                : const Color(0x99FFFFFF),
                            fontWeight: isLoginSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            letterSpacing: 0.5,
                            fontSize: ResponsiveConfig.fontSize(14),
                          ),
                          child: const Text('Iniciar Sesión'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: onRegisterClick,
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: !isLoginSelected
                                ? Colors.white
                                : const Color(0x99FFFFFF),
                            fontWeight: !isLoginSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            letterSpacing: 0.5,
                            fontSize: ResponsiveConfig.fontSize(14),
                          ),
                          child: const Text('Registrarse'),
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
