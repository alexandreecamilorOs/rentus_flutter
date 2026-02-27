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
import '../../components/modern_view_wrapper.dart';

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
                  padding: ResponsiveConfig.adaptivePadding(horizontal: 16, vertical: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = ResponsiveConfig.byBreakpoint<double>(
                        smallMobile: 340,
                        mobile: 500,
                        tablet: 740,
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
                                isLoginSelected: false,
                                onLoginClick: () => context.go('/login'),
                                onRegisterClick: () {},
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              Text(
                                'Crea tu cuenta',
                                style: TextStyle(
                                  fontSize: ResponsiveConfig.fontSize(24),
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(4)),
                              Text(
                                'Completa tus datos para comenzar',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: ResponsiveConfig.fontSize(14),
                                ),
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              AuthInputField(
                                value: _name,
                                onValueChange: (val) => setState(() => _name = val),
                                label: 'Nombre completo',
                                leadingIcon: Icons.person,
                              ),
                              AuthInputField(
                                value: _email,
                                onValueChange: (val) => setState(() => _email = val),
                                label: 'Email',
                                leadingIcon: Icons.email,
                              ),
                              AuthInputField(
                                value: _phone,
                                onValueChange: (val) => setState(() => _phone = val),
                                label: 'Teléfono',
                                leadingIcon: Icons.phone,
                              ),
                              AuthInputField(
                                value: _idDocument,
                                onValueChange: (val) => setState(() => _idDocument = val),
                                label: 'Documento de identidad',
                                leadingIcon: Icons.badge,
                              ),
                              AuthInputField(
                                value: _address,
                                onValueChange: (val) => setState(() => _address = val),
                                label: 'Dirección',
                                leadingIcon: Icons.location_on,
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
                                    value: _acceptTerms,
                                    onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                                    activeColor: AppColors.primary,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Acepto los ',
                                          style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: ResponsiveConfig.fontSize(14),
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: 'términos y condiciones',
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
                                text: 'Crear Cuenta',
                                enabled: _isFormValid,
                                isLoading: _isLoading,
                                onClick: _onRegisterClick,
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              const DividerWithText(text: 'O regístrate con'),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              SocialButton(
                                text: 'Registrarse con Google',
                                onClick: () {},
                              ),
                              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
                              Center(
                                child: GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '¿Ya tienes una cuenta? ',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: ResponsiveConfig.fontSize(14),
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'Inicia sesión aquí',
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
