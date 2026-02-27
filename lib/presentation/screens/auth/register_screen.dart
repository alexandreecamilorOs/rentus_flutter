import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  void _onRegisterClick() async {
    setState(() => _isLoading = true);
    // Simular llamada de red
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
              const Positioned(
                top: 28,
                left: 28,
                child: BrandLogo(),
              ),
              Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
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
                          isLoginSelected: false,
                          onLoginClick: () => context.go('/login'),
                          onRegisterClick: () {},
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Crea tu cuenta',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Completa tus datos para comenzar',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 24),
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
                          onValueChange: (val) =>
                              setState(() => _idDocument = val),
                          label: 'Documento de identidad',
                          leadingIcon: Icons.badge,
                        ),
                        AuthInputField(
                          value: _address,
                          onValueChange: (val) =>
                              setState(() => _address = val),
                          label: 'Dirección',
                          leadingIcon: Icons.location_on,
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
                              value: _acceptTerms,
                              onChanged: (val) =>
                                  setState(() => _acceptTerms = val ?? false),
                              activeColor: AppColors.primary,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: RichText(
                                  text: const TextSpan(
                                    text: 'Acepto los ',
                                    style:
                                        TextStyle(color: AppColors.textPrimary),
                                    children: [
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        const SizedBox(height: 8),
                        AuthButton(
                          text: 'Crear Cuenta',
                          enabled: _isFormValid,
                          isLoading: _isLoading,
                          onClick: _onRegisterClick,
                        ),
                        const SizedBox(height: 24),
                        const DividerWithText(text: 'O regístrate con'),
                        const SizedBox(height: 24),
                        SocialButton(
                          text: 'Registrarse con Google',
                          onClick: () {},
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: GestureDetector(
                            onTap: () => context.go('/login'),
                            child: RichText(
                              text: const TextSpan(
                                text: '¿Ya tienes una cuenta? ',
                                style:
                                    TextStyle(color: AppColors.textSecondary),
                                children: [
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
