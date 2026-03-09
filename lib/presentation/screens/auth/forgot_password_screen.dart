import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive_config.dart';
import '../../../data/providers/auth_provider.dart';
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
      setState(
          () => _errorMessage = 'Por favor, ingresa tu correo electrónico.');
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
            backgroundColor: Color(0xFF15100E),
            content: Text('Código de recuperación enviado. Revisa tu correo.',
                style: TextStyle(color: Colors.white))),
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
                          GestureDetector(
                            onTap: () {
                              if (context.canPop()) {
                                context.pop();
                              } else {
                                context.go('/login');
                              }
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
                              height:
                                  ResponsiveConfig.getProportionateScreenHeight(
                                      24)),
                          const Text(
                            'Recuperar Contraseña',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveConfig.getProportionateScreenHeight(
                                      6)),
                          const Text(
                            'Ingresa tu correo y te enviaremos un código para restablecer tu contraseña.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0x99FFFFFF),
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(
                              height:
                                  ResponsiveConfig.getProportionateScreenHeight(
                                      32)),
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
                                    .getProportionateScreenHeight(24)),
                          ],
                          AuthInputField(
                            label: 'Correo Electrónico',
                            value: _emailController.text,
                            onValueChange: (v) =>
                                setState(() => _emailController.text = v),
                            leadingIcon: Icons.email_rounded,
                          ),
                          SizedBox(
                              height:
                                  ResponsiveConfig.getProportionateScreenHeight(
                                      32)),
                          AuthButton(
                            text: 'Enviar Código',
                            onClick: _onSubmit,
                            isLoading: _isLoading,
                          ),
                          SizedBox(
                              height:
                                  ResponsiveConfig.getProportionateScreenHeight(
                                      8)),
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
