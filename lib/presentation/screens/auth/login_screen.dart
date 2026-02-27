import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive_config.dart';
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

  Future<void> _onLoginClick() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final contentWidth = ResponsiveConfig.byBreakpoint<double>(
            smallMobile: 340,
            mobile: isLandscape ? 560 : 460,
            tablet: 720,
          );

          return AuthBackground(
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF241711),
                          const Color(0xFF3B251D).withOpacity(0.92),
                          const Color(0xFF1A1210).withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: ResponsiveConfig.adaptivePadding(horizontal: 16, vertical: 16),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: ResponsiveConfig.adaptiveSpacing(mobile: 8),
                              top: ResponsiveConfig.adaptiveSpacing(mobile: 8),
                            ),
                            child: const BrandLogo(),
                          ),
                        ),
                        SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(22)),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: ResponsiveConfig.getProportionateScreenWidth(contentWidth)),
                          child: AuthModal(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (context.canPop()) context.pop();
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_back, color: Color(0xFFF6E6D1)),
                                      SizedBox(width: ResponsiveConfig.getProportionateScreenWidth(8)),
                                      Text(
                                        'Volver',
                                        style: TextStyle(
                                          color: const Color(0xFFF6E6D1),
                                          fontSize: ResponsiveConfig.fontSize(14),
                                        ),
                                      ),
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
                                    color: Colors.white,
                                    fontSize: ResponsiveConfig.fontSize(26),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(6)),
                                Text(
                                  'Ingresa tus credenciales para continuar',
                                  style: TextStyle(
                                    color: const Color(0xFFEADFCF),
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
                                      activeColor: const Color(0xFFFFD672),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Recordarme',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ResponsiveConfig.fontSize(13),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '¿Olvidaste tu contraseña?',
                                      style: TextStyle(
                                        color: const Color(0xFFFFD672),
                                        fontSize: ResponsiveConfig.fontSize(12),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_errorMessage != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveConfig.getProportionateScreenHeight(8),
                                    ),
                                    child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
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
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(20)),
                                SocialButton(text: 'Continuar con Google', onClick: () {}),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(22)),
                                Center(
                                  child: GestureDetector(
                                    onTap: () => context.go('/register'),
                                    child: Text.rich(
                                      TextSpan(
                                        text: '¿No tienes una cuenta? ',
                                        style: TextStyle(
                                          color: const Color(0xFFEADFCF),
                                          fontSize: ResponsiveConfig.fontSize(14),
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: 'Regístrate gratis',
                                            style: TextStyle(
                                              color: Color(0xFFFFD672),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
