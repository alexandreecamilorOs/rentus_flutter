import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/user_model.dart';
import '../../../data/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _idDoc = TextEditingController();
  final _address = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nombre')),
          TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email')),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Teléfono')),
          TextField(controller: _idDoc, decoration: const InputDecoration(labelText: 'Documento')),
          TextField(controller: _address, decoration: const InputDecoration(labelText: 'Dirección')),
          TextField(controller: _password, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
          if (auth.message != null) Text(auth.message!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: auth.status == AuthStatus.loading
                ? null
                : () async {
                    final ok = await ref.read(authProvider.notifier).register(
                          RegisterData(
                            name: _name.text.trim(),
                            email: _email.text.trim(),
                            phone: _phone.text.trim(),
                            idDocument: _idDoc.text.trim(),
                            address: _address.text.trim(),
                            password: _password.text,
                          ),
                        );
                    if (!mounted || !ok) return;
                    context.go('/verify-email');
                  },
            child: Text(auth.status == AuthStatus.loading ? 'Registrando...' : 'Registrar'),
          ),
          TextButton(onPressed: () => context.go('/login'), child: const Text('Ya tengo cuenta')),
        ],
      ),
    );
  }
}
