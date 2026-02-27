import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/entity_providers.dart';

class PropertiesScreen extends ConsumerStatefulWidget {
  const PropertiesScreen({super.key});

  @override
  ConsumerState<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends ConsumerState<PropertiesScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(propertyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Propiedades'),
        actions: [IconButton(onPressed: () => context.go('/properties/create'), icon: const Icon(Icons.add))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ciudad o título',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => ref.invalidate(propertyListProvider),
                ),
              ),
            ),
          ),
          Expanded(
            child: state.when(
              data: (data) {
                if (data.items.isEmpty) return const Center(child: Text('Sin propiedades publicadas'));
                return ListView.builder(
                  itemCount: data.items.length + (data.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == data.items.length) {
                      ref.read(propertyListProvider.notifier).loadNextPage();
                      return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
                    }
                    final property = data.items[index];
                    final image = property.propertyImages.isNotEmpty ? property.propertyImages.first.url : null;
                    return ListTile(
                      leading: image != null && image.isNotEmpty
                          ? CircleAvatar(backgroundImage: NetworkImage(image))
                          : const CircleAvatar(child: Icon(Icons.home_work_outlined)),
                      title: Text(property.title),
                      subtitle: Text('${property.city} · ${property.price ?? 0}'),
                      onTap: () => context.go('/properties/${property.id}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
