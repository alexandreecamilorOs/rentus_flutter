import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/entity_providers.dart';

class PropertyDetailScreen extends ConsumerWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final int propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(propertyDetailProvider(propertyId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Propiedad'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.go('/properties/$propertyId/edit'),
          ),
        ],
      ),
      body: detail.when(
        data: (property) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(property.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(property.description),
            const SizedBox(height: 8),
            Text('Ciudad: ${property.city}'),
            Text('Estado aprobación: ${property.approvalStatus ?? '-'}'),
            Text('Visibilidad: ${property.visibility ?? '-'}'),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
