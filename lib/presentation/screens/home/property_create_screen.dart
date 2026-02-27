import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/repositories_providers.dart';

class PropertyCreateScreen extends ConsumerStatefulWidget {
  const PropertyCreateScreen({super.key});

  @override
  ConsumerState<PropertyCreateScreen> createState() => _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends ConsumerState<PropertyCreateScreen> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _city = TextEditingController();
  bool _saving = false;

  Future<void> _submit() async {
    setState(() => _saving = true);
    try {
      await ref.read(propertyRepositoryProvider).createProperty({
        'title': _title.text,
        'description': _description.text,
        'city': _city.text,
      });
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Propiedad creada')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Propiedad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Título')),
          TextField(controller: _description, decoration: const InputDecoration(labelText: 'Descripción')),
          TextField(controller: _city, decoration: const InputDecoration(labelText: 'Ciudad')),
          const SizedBox(height: 16),
          FilledButton(onPressed: _saving ? null : _submit, child: Text(_saving ? 'Guardando...' : 'Guardar')),
        ],
      ),
    );
  }
}
