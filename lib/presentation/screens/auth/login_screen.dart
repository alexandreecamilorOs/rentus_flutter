import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive_config.dart';
import '../../../data/providers/auth_provider.dart';
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

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _onLoginClick() async {
    final emailTrimmed = _email.trim();
    if (emailTrimmed.isEmpty || _password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, completa todos los campos.');
      return;
    }

    if (!_isValidEmail(emailTrimmed)) {
      setState(() => _errorMessage = 'Por favor, ingresa un email válido.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ok = await ref.read(authProvider.notifier).login(
          emailTrimmed,
          _password,
          remember: _rememberMe,
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (ok) {
      context.go('/home');
      return;
    }

    final authState = ref.read(authProvider);
    if (authState.pendingVerificationEmail != null) {
      context.go('/verify-email');
      return;
    }

    setState(() => _errorMessage = authState.message);
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
                  padding: EdgeInsets.only(
                    top: ResponsiveConfig.getProportionateScreenHeight(120),
                    bottom: ResponsiveConfig.getProportionateScreenHeight(24),
                    left: ResponsiveConfig.adaptiveSpacing(mobile: 16),
                    right: ResponsiveConfig.adaptiveSpacing(mobile: 16),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = ResponsiveConfig.byBreakpoint<double>(
                        smallMobile: 340,
                        mobile: 480,
                        tablet: 620,
                      );

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              ResponsiveConfig.getProportionateScreenWidth(
                                  width),
                        ),
                        child: AuthModal(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(8)),
                              GestureDetector(
                                onTap: () {
                                  if (context.canPop()) context.pop();
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.arrow_back,
                                        color: Color(0x99FFFFFF)),
                                    SizedBox(
                                        width: ResponsiveConfig
                                            .getProportionateScreenWidth(8)),
                                    const Text('Volver',
                                        style: TextStyle(
                                            color: Color(0x99FFFFFF),
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              AuthTabRow(
                                isLoginSelected: true,
                                onLoginClick: () {},
                                onRegisterClick: () => context.go('/register'),
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              Text(
                                'Accede a tu cuenta',
                                style: TextStyle(
                                  fontSize: ResponsiveConfig.fontSize(24),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(4)),
                              Text(
                                'Ingresa tus credenciales para continuar',
                                style: TextStyle(
                                  color: const Color(0x99FFFFFF),
                                  fontSize: ResponsiveConfig.fontSize(14),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              AuthInputField(
                                value: _email,
                                onValueChange: (val) =>
                                    setState(() => _email = val),
                                label: 'Email',
                                leadingIcon: Icons.email_rounded,
                              ),
                              AuthInputField(
                                value: _password,
                                onValueChange: (val) =>
                                    setState(() => _password = val),
                                label: 'Contraseña',
                                leadingIcon: Icons.lock_rounded,
                                isPassword: true,
                                isPasswordVisible: _isPasswordVisible,
                                onTogglePasswordVisibility: () {
                                  setState(() =>
                                      _isPasswordVisible = !_isPasswordVisible);
                                },
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) => setState(
                                        () => _rememberMe = val ?? false),
                                    activeColor: const Color(0xFFFFD59A),
                                    checkColor: const Color(0xFF15100E),
                                    side: const BorderSide(
                                        color: Color(0x66FFFFFF), width: 1.5),
                                  ),
                                  const Text('Recordarme',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => context.go('/forgot-password'),
                                    child: Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(
                                        color: const Color(0xFFFFD59A),
                                        fontSize: ResponsiveConfig.fontSize(12),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_errorMessage != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.red.withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: Color(0xFFFF6B6B), size: 20),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _errorMessage!,
                                          style: const TextStyle(
                                              color: Color(0xFFFF6B6B),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: ResponsiveConfig
                                        .getProportionateScreenHeight(16)),
                              ],
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(8)),
                              AuthButton(
                                text: 'Iniciar Sesión',
                                enabled: _isFormValid,
                                isLoading: _isLoading,
                                onClick: _onLoginClick,
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              const DividerWithText(text: 'O continúa con'),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              SocialButton(
                                text: 'Continuar con Google',
                                onClick: () {},
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              Center(
                                child: GestureDetector(
                                  onTap: () => context.go('/register'),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '¿No tienes una cuenta? ',
                                      style: TextStyle(
                                        color: const Color(0x99FFFFFF),
                                        fontSize: ResponsiveConfig.fontSize(14),
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'Regístrate gratis',
                                          style: TextStyle(
                                            color: Color(0xFFFFD59A),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(8)),
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
