import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';

class PropertyEditScreen extends ConsumerStatefulWidget {
  const PropertyEditScreen({super.key, required this.propertyId});
  final int propertyId;

  @override
  ConsumerState<PropertyEditScreen> createState() => _PropertyEditScreenState();
}

class _PropertyEditScreenState extends ConsumerState<PropertyEditScreen> {
  final _title = TextEditingController();
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(propertyDetailProvider(widget.propertyId));
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Propiedad')),
      body: detail.when(
        data: (property) {
          if (!_initialized) {
            _title.text = property.title;
            _initialized = true;
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: _title, decoration: const InputDecoration(labelText: 'Título')),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () async {
                    await ref.read(propertyRepositoryProvider).updateProperty(widget.propertyId, {'title': _title.text});
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Actualizar'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
