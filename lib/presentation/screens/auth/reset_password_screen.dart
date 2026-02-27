import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/auth_provider.dart';

class ResetPasswordScreen extends ConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = TextEditingController();
    final code = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Restablecer contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: token, decoration: const InputDecoration(labelText: 'Token')),
            TextField(controller: code, decoration: const InputDecoration(labelText: 'Código')),
            TextField(controller: password, decoration: const InputDecoration(labelText: 'Nueva contraseña')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).resetPassword(token: token.text.trim(), code: code.text.trim(), password: password.text);
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Actualizar contraseña'),
            )
          ],
        ),
      ),
    );
  }
}
