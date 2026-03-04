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
import '../../components/brand_logo.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email;
  const ResetPasswordScreen({super.key, this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  late final TextEditingController _emailController;
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  Future<void> _onSubmit() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty || code.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Por favor completa todos los campos.');
      return;
    }

    if (password != confirm) {
      setState(() => _errorMessage = 'Las contraseñas no coinciden.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ok = await ref.read(authProvider.notifier).resetPassword(
          email: email,
          code: code,
          password: password,
          passwordConfirmation: confirm,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contraseña restablecida exitosamente.')),
      );
      context.go('/login');
    } else {
      setState(() => _errorMessage =
          ref.read(authProvider).message ?? 'Error al restablecer contraseña.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                      horizontal: 16, vertical: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          ResponsiveConfig.getProportionateScreenWidth(480),
                    ),
                    child: AuthModal(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back),
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Nueva Contraseña',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ingresa el código que recibiste y tu nueva contraseña.',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(
                                    color: Colors.red.shade700, fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          AuthInputField(
                            label: 'Correo Electrónico',
                            value: _emailController.text,
                            onValueChange: (v) =>
                                setState(() => _emailController.text = v),
                            leadingIcon: Icons.email_outlined,
                          ),
                          AuthInputField(
                            label: 'Código de recuperación',
                            value: _codeController.text,
                            onValueChange: (v) =>
                                setState(() => _codeController.text = v),
                            leadingIcon: Icons.lock_clock_outlined,
                          ),
                          AuthInputField(
                            label: 'Nueva Contraseña',
                            value: _passwordController.text,
                            onValueChange: (v) =>
                                setState(() => _passwordController.text = v),
                            leadingIcon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordVisible: _isPasswordVisible,
                            onTogglePasswordVisibility: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                          ),
                          AuthInputField(
                            label: 'Confirmar Contraseña',
                            value: _confirmPasswordController.text,
                            onValueChange: (v) => setState(
                                () => _confirmPasswordController.text = v),
                            leadingIcon: Icons.lock_outline,
                            isPassword: true,
                            isPasswordVisible: _isPasswordVisible,
                            onTogglePasswordVisibility: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                          ),
                          const SizedBox(height: 32),
                          AuthButton(
                            text: 'Cambiar Contraseña',
                            onClick: _onSubmit,
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
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
