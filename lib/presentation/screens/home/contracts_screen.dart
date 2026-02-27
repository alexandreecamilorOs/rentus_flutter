import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/contract_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';

class ContractsScreen extends ConsumerWidget {
  const ContractsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contracts = ref.watch(myContractsProvider);

    Future<void> update(Contract c, bool accept) async {
      if (accept) {
        await ref.read(contractRepositoryProvider).acceptContract(c.id);
      } else {
        await ref.read(contractRepositoryProvider).rejectContract(c.id);
      }
      ref.invalidate(myContractsProvider);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Contratos')),
      body: contracts.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final c = items[index];
            return Card(
              child: ListTile(
                title: Text('Contrato #${c.id}'),
                subtitle: Text('Estado: ${c.status}'),
                trailing: c.status == 'pending'
                    ? Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton(onPressed: () => update(c, false), child: const Text('Rechazar')),
                          FilledButton(onPressed: () => update(c, true), child: const Text('Aceptar')),
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
