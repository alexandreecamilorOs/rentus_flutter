import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/auth_background.dart';
import '../../components/auth_button.dart';
import '../../components/auth_input_field.dart';
import '../../components/auth_modal.dart';
import '../../components/auth_tab_row.dart';
import '../../components/brand_logo.dart';
import '../../components/divider_with_text.dart';
import '../../components/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get _isFormValid => _email.isNotEmpty && _password.isNotEmpty;

  void _onLoginClick() async {
    setState(() => _isLoading = true);
    // Simular llamada de red
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 28,
                left: 28,
                child: BrandLogo(),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AuthModal(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            if (context.canPop()) context.pop();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back,
                                  color: AppColors.textSecondary),
                              SizedBox(width: 8),
                              Text('Volver',
                                  style: TextStyle(
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AuthTabRow(
                          isLoginSelected: true,
                          onLoginClick: () {},
                          onRegisterClick: () => context.go('/register'),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Accede a tu cuenta',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ingresa tus credenciales para continuar',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
                        AuthInputField(
                          value: _email,
                          onValueChange: (val) => setState(() => _email = val),
                          label: 'Email',
                          leadingIcon: Icons.email,
                        ),
                        AuthInputField(
                          value: _password,
                          onValueChange: (val) =>
                              setState(() => _password = val),
                          label: 'Contraseña',
                          leadingIcon: Icons.lock,
                          isPassword: true,
                          isPasswordVisible: _isPasswordVisible,
                          onTogglePasswordVisibility: () {
                            setState(
                                () => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (val) =>
                                  setState(() => _rememberMe = val ?? false),
                              activeColor: AppColors.primary,
                            ),
                            const Text('Recordarme',
                                style: TextStyle(color: AppColors.textPrimary)),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        const SizedBox(height: 8),
                        AuthButton(
                          text: 'Iniciar Sesión',
                          enabled: _isFormValid,
                          isLoading: _isLoading,
                          onClick: _onLoginClick,
                        ),
                        const SizedBox(height: 24),
                        const DividerWithText(text: 'O continúa con'),
                        const SizedBox(height: 24),
                        SocialButton(
                          text: 'Continuar con Google',
                          onClick: () {},
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: GestureDetector(
                            onTap: () => context.go('/register'),
                            child: RichText(
                              text: const TextSpan(
                                text: '¿No tienes una cuenta? ',
                                style:
                                    TextStyle(color: AppColors.textSecondary),
                                children: [
                                  TextSpan(
                                    text: 'Regístrate gratis',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
