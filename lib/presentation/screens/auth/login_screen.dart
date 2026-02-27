import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _remember = false;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      if (next.isAuthenticated) context.go('/home');
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
            CheckboxListTile(
              value: _remember,
              onChanged: (value) => setState(() => _remember = value ?? false),
              title: const Text('Recordarme'),
              contentPadding: EdgeInsets.zero,
            ),
            if (authState.message != null) Text(authState.message!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: authState.status == AuthStatus.loading
                  ? null
                  : () => ref.read(authProvider.notifier).login(_emailController.text.trim(), _passwordController.text, remember: _remember),
              child: Text(authState.status == AuthStatus.loading ? 'Ingresando...' : 'Ingresar'),
            ),
            TextButton(onPressed: () => context.go('/register'), child: const Text('Crear cuenta')),
            TextButton(onPressed: () => context.go('/forgot-password'), child: const Text('Olvidé mi contraseña')),
          ],
        ),
      ),
    );
  }
}
