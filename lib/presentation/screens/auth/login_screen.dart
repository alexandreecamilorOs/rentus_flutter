import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive_config.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/auth_background.dart';
import '../../components/auth_button.dart';
import '../../components/auth_input_field.dart';
import '../../components/auth_modal.dart';
import '../../components/auth_tab_row.dart';
import '../../components/brand_logo.dart';
import '../../components/divider_with_text.dart';
import '../../components/social_button.dart';
import '../../components/modern_view_wrapper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get _isFormValid => _email.isNotEmpty && _password.isNotEmpty;

  Future<void> _onLoginClick() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ok = await ref.read(authProvider.notifier).login(
          _email.trim(),
          _password,
          remember: _rememberMe,
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (ok) {
      context.go('/home');
      return;
    }

    final message = ref.read(authProvider).message ?? 'No fue posible iniciar sesión.';
    setState(() {
      _errorMessage = message.contains('connection error') || message.contains('XMLHttpRequest')
          ? 'No se pudo conectar con el servidor. Verifica internet/CORS del backend.'
          : message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: ResponsiveConfig.getProportionateScreenHeight(28),
                left: ResponsiveConfig.getProportionateScreenWidth(28),
                child: const BrandLogo(),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: ResponsiveConfig.adaptivePadding(horizontal: 16, vertical: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = ResponsiveConfig.byBreakpoint<double>(
                        smallMobile: 340,
                        mobile: 480,
                        tablet: 620,
                      );

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveConfig.getProportionateScreenWidth(width),
                        ),
                        child: AuthModal(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(8)),
                              GestureDetector(
                                onTap: () {
                                  if (context.canPop()) context.pop();
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_back, color: AppColors.textSecondary),
                                    SizedBox(width: ResponsiveConfig.getProportionateScreenWidth(8)),
                                    const Text('Volver', style: TextStyle(color: AppColors.textSecondary)),
                                  ],
                                ),
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              AuthTabRow(
                                isLoginSelected: true,
                                onLoginClick: () {},
                                onRegisterClick: () => context.go('/register'),
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              Text(
                                'Accede a tu cuenta',
                                style: TextStyle(
                                  fontSize: ResponsiveConfig.fontSize(24),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(4)),
                              Text(
                                'Ingresa tus credenciales para continuar',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveConfig.fontSize(14),
                                ),
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              AuthInputField(
                                value: _email,
                                onValueChange: (val) => setState(() => _email = val),
                                label: 'Email',
                                leadingIcon: Icons.email,
                              ),
                              AuthInputField(
                                value: _password,
                                onValueChange: (val) => setState(() => _password = val),
                                label: 'Contraseña',
                                leadingIcon: Icons.lock,
                                isPassword: true,
                                isPasswordVisible: _isPasswordVisible,
                                onTogglePasswordVisibility: () {
                                  setState(() => _isPasswordVisible = !_isPasswordVisible);
                                },
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) => setState(() => _rememberMe = val ?? false),
                                    activeColor: AppColors.primary,
                                  ),
                                  const Text('Recordarme', style: TextStyle(color: AppColors.textPrimary)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => context.go('/forgot-password'),
                                    child: Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: ResponsiveConfig.fontSize(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_errorMessage != null)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: ResponsiveConfig.getProportionateScreenHeight(8),
                                  ),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: AppColors.error),
                                  ),
                                ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(8)),
                              AuthButton(
                                text: 'Iniciar Sesión',
                                enabled: _isFormValid,
                                isLoading: _isLoading,
                                onClick: _onLoginClick,
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              const DividerWithText(text: 'O continúa con'),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              SocialButton(
                                text: 'Continuar con Google',
                                onClick: () {},
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              Center(
                                child: GestureDetector(
                                  onTap: () => context.go('/register'),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '¿No tienes una cuenta? ',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: ResponsiveConfig.fontSize(14),
                                      ),
                                      children: const [
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
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(8)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).modernWrapped();
  }
}
