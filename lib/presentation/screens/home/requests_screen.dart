import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/rental_request_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(myRequestsProvider);

    Future<void> act(RentalRequest req, String action) async {
      final repo = ref.read(rentalRequestRepositoryProvider);
      if (action == 'accept') await repo.acceptRequest(req.id);
      if (action == 'reject') await repo.rejectRequest(req.id);
      ref.invalidate(myRequestsProvider);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes de arriendo')),
      body: requests.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final r = items[index];
            return Card(
              child: ListTile(
                title: Text('Solicitud #${r.id} · Propiedad ${r.propertyId}'),
                subtitle: Text('Estado: ${r.status}'),
                trailing: r.status == 'pending'
                    ? Wrap(
                        spacing: 8,
                        children: [
                          TextButton(onPressed: () => act(r, 'reject'), child: const Text('Rechazar')),
                          FilledButton(onPressed: () => act(r, 'accept'), child: const Text('Aceptar')),
                        ],
                      )
                    : null,
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
