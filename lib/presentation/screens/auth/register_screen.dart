import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive_config.dart';
import '../../../core/theme/app_colors.dart';
import '../../components/auth_background.dart';
import '../../components/auth_button.dart';
import '../../components/auth_input_field.dart';
import '../../components/auth_modal.dart';
import '../../components/auth_tab_row.dart';
import '../../components/brand_logo.dart';
import '../../components/divider_with_text.dart';
import '../../components/social_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _name = '';
  String _email = '';
  String _phone = '';
  String _idDocument = '';
  String _address = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _acceptTerms = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get _isFormValid =>
      _name.isNotEmpty &&
      _email.isNotEmpty &&
      _phone.isNotEmpty &&
      _idDocument.isNotEmpty &&
      _address.isNotEmpty &&
      _password.isNotEmpty &&
      _acceptTerms;

  Future<void> _onRegisterClick() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > constraints.maxHeight;
          final contentWidth = ResponsiveConfig.byBreakpoint<double>(
            smallMobile: 340,
            mobile: isLandscape ? 620 : 490,
            tablet: 760,
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
                        SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(18)),
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
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(22)),
                                AuthTabRow(
                                  isLoginSelected: false,
                                  onLoginClick: () => context.go('/login'),
                                  onRegisterClick: () {},
                                ),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(22)),
                                Text(
                                  'Crea tu cuenta',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ResponsiveConfig.fontSize(26),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(6)),
                                Text(
                                  'Completa tus datos para comenzar',
                                  style: TextStyle(
                                    color: const Color(0xFFEADFCF),
                                    fontSize: ResponsiveConfig.fontSize(14),
                                  ),
                                ),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(22)),
                                AuthInputField(value: _name, onValueChange: (val) => setState(() => _name = val), label: 'Nombre completo', leadingIcon: Icons.person),
                                AuthInputField(value: _email, onValueChange: (val) => setState(() => _email = val), label: 'Email', leadingIcon: Icons.email),
                                AuthInputField(value: _phone, onValueChange: (val) => setState(() => _phone = val), label: 'Teléfono', leadingIcon: Icons.phone),
                                AuthInputField(value: _idDocument, onValueChange: (val) => setState(() => _idDocument = val), label: 'Documento de identidad', leadingIcon: Icons.badge),
                                AuthInputField(value: _address, onValueChange: (val) => setState(() => _address = val), label: 'Dirección', leadingIcon: Icons.location_on),
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
                                      value: _acceptTerms,
                                      onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                                      activeColor: const Color(0xFFFFD672),
                                    ),
                                    Expanded(
                                      child: Text.rich(
                                        TextSpan(
                                          text: 'Acepto los ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ResponsiveConfig.fontSize(14),
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: 'términos y condiciones',
                                              style: TextStyle(
                                                color: Color(0xFFFFD672),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_errorMessage != null)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: ResponsiveConfig.getProportionateScreenHeight(8)),
                                    child: Text(_errorMessage!, style: const TextStyle(color: AppColors.error)),
                                  ),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(8)),
                                AuthButton(text: 'Crear Cuenta', enabled: _isFormValid, isLoading: _isLoading, onClick: _onRegisterClick),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                                const DividerWithText(text: 'O regístrate con'),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(20)),
                                SocialButton(text: 'Registrarse con Google', onClick: () {}),
                                SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(20)),
                                Center(
                                  child: GestureDetector(
                                    onTap: () => context.go('/login'),
                                    child: Text.rich(
                                      TextSpan(
                                        text: '¿Ya tienes una cuenta? ',
                                        style: TextStyle(
                                          color: const Color(0xFFEADFCF),
                                          fontSize: ResponsiveConfig.fontSize(14),
                                        ),
                                        children: const [
                                          TextSpan(
                                            text: 'Inicia sesión aquí',
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
