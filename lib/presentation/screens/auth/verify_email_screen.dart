import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Verificar Email')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Código enviado a: ${auth.pendingVerificationEmail ?? '-'}'),
            TextField(controller: _code, decoration: const InputDecoration(labelText: 'Código OTP (6 dígitos)')),
            if (auth.message != null) Text(auth.message!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final ok = await ref.read(authProvider.notifier).verifyEmail(_code.text.trim());
                if (!mounted) return;
                if (ok) {
                  context.go('/home');
                }
              },
              child: const Text('Verificar'),
            ),
            TextButton(
              onPressed: () async {
                await ref.read(authProvider.notifier).resendCode();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código reenviado')));
              },
              child: const Text('Reenviar código'),
            )
          ],
        ),
      ),
    );
  }
}
