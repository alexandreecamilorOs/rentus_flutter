import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive_config.dart';
import '../../../data/models/user_model.dart';
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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
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

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _onRegisterClick() async {
    final emailTrimmed = _email.trim();
    if (emailTrimmed.isEmpty ||
        _name.isEmpty ||
        _phone.isEmpty ||
        _idDocument.isEmpty ||
        _address.isEmpty ||
        _password.isEmpty) {
      setState(() => _errorMessage = 'Por favor, completa todos los campos.');
      return;
    }

    if (!_isValidEmail(emailTrimmed)) {
      setState(() => _errorMessage = 'Por favor, ingresa un email válido.');
      return;
    }

    if (_password.length < 6) {
      setState(() =>
          _errorMessage = 'La contraseña debe tener al menos 6 caracteres.');
      return;
    }

    if (!_acceptTerms) {
      setState(
          () => _errorMessage = 'Debes aceptar los términos y condiciones.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ok = await ref.read(authProvider.notifier).register(
          RegisterData(
            name: _name.trim(),
            email: emailTrimmed,
            phone: _phone.trim(),
            idDocument: _idDocument.trim(),
            address: _address.trim(),
            password: _password,
          ),
        );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (ok) {
      context.go('/verify-email');
      return;
    }

    setState(() => _errorMessage = ref.read(authProvider).message);
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
                  padding: ResponsiveConfig.adaptivePadding(
                      horizontal: 16, vertical: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = ResponsiveConfig.byBreakpoint<double>(
                        smallMobile: 340,
                        mobile: 500,
                        tablet: 740,
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
                                isLoginSelected: false,
                                onLoginClick: () => context.go('/login'),
                                onRegisterClick: () {},
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              Text(
                                'Crea tu cuenta',
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
                                'Completa tus datos para comenzar',
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
                                value: _name,
                                onValueChange: (val) =>
                                    setState(() => _name = val),
                                label: 'Nombre completo',
                                leadingIcon: Icons.person_rounded,
                              ),
                              AuthInputField(
                                value: _email,
                                onValueChange: (val) =>
                                    setState(() => _email = val),
                                label: 'Email',
                                leadingIcon: Icons.email_rounded,
                              ),
                              AuthInputField(
                                value: _phone,
                                onValueChange: (val) =>
                                    setState(() => _phone = val),
                                label: 'Teléfono',
                                leadingIcon: Icons.phone_rounded,
                              ),
                              AuthInputField(
                                value: _idDocument,
                                onValueChange: (val) =>
                                    setState(() => _idDocument = val),
                                label: 'Documento de identidad',
                                leadingIcon: Icons.badge_rounded,
                              ),
                              AuthInputField(
                                value: _address,
                                onValueChange: (val) =>
                                    setState(() => _address = val),
                                label: 'Dirección',
                                leadingIcon: Icons.location_on_rounded,
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
                                    value: _acceptTerms,
                                    onChanged: (val) => setState(
                                        () => _acceptTerms = val ?? false),
                                    activeColor: const Color(0xFFFFD59A),
                                    checkColor: const Color(0xFF15100E),
                                    side: const BorderSide(
                                        color: Color(0x66FFFFFF), width: 1.5),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Acepto los ',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                ResponsiveConfig.fontSize(14),
                                          ),
                                          children: const [
                                            TextSpan(
                                              text: 'términos y condiciones',
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
                                text: 'Crear Cuenta',
                                enabled: _isFormValid,
                                isLoading: _isLoading,
                                onClick: _onRegisterClick,
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              const DividerWithText(text: 'O regístrate con'),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              SocialButton(
                                text: 'Registrarse con Google',
                                onClick: () {},
                              ),
                              SizedBox(
                                  height: ResponsiveConfig
                                      .getProportionateScreenHeight(24)),
                              Center(
                                child: GestureDetector(
                                  onTap: () => context.go('/login'),
                                  child: RichText(
                                    text: TextSpan(
                                      text: '¿Ya tienes una cuenta? ',
                                      style: TextStyle(
                                        color: const Color(0x99FFFFFF),
                                        fontSize: ResponsiveConfig.fontSize(14),
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'Inicia sesión aquí',
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
