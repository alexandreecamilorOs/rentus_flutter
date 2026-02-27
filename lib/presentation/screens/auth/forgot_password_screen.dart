import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: controller, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () async {
                await ref.read(authRepositoryProvider).forgotPassword(controller.text.trim());
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código enviado')));
              },
              child: const Text('Enviar código'),
            )
          ],
        ),
      ),
    );
  }
}
