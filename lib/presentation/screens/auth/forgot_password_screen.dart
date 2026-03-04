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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _onSubmit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Ingresa tu correo electrónico.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final ok = await ref.read(authProvider.notifier).forgotPassword(email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Código de recuperación enviado. Revisa tu correo.')),
      );
      context.push('/reset-password', extra: email);
    } else {
      setState(() => _errorMessage =
          ref.read(authProvider).message ?? 'Error al solicitar recuperación.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
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
                            'Recuperar Contraseña',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ingresa tu correo y te enviaremos un código para restablecer tu contraseña.',
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
                          const SizedBox(height: 32),
                          AuthButton(
                            text: 'Enviar Código',
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
