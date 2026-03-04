import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/entity_providers.dart';
import '../../../data/models/property_model.dart';
import '../../components/app_action_button.dart';
import '../../components/home_navbar.dart';

class PropertiesScreen extends ConsumerStatefulWidget {
  const PropertiesScreen({super.key});

  @override
  ConsumerState<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends ConsumerState<PropertiesScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'Todos';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(propertyListProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertyListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          // 1. Cinematic Background
          const _CinematicBackground(),

          // 2. Main Content
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header & Search
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Explorar",
                                  style: TextStyle(
                                    color: const Color(0xFFDA9C5F)
                                        .withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const Text(
                                  "Propiedades",
                                  style: TextStyle(
                                    color: Color(0xFFF0E5DB),
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            _CreateActionButton(
                              onTap: () => context.push('/properties/create'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _SearchBar(
                          controller: _searchController,
                          onSearch: (val) {
                            // Filter logic could be added here or via provider
                          },
                        ),
                        const SizedBox(height: 16),
                        _FilterChips(
                          selectedType: _selectedType,
                          onSelected: (type) {
                            setState(() => _selectedType = type);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Properties Grid
                propertiesAsync.when(
                  data: (state) {
                    if (state.items.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(child: _EmptyState()),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 450,
                          mainAxisExtent: 460,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final property = state.items[index];
                            return _PropertyCard(property: property);
                          },
                          childCount: state.items.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => SliverFillRemaining(
                    child: Center(
                      child: _ErrorState(
                        onRetry: () => ref.invalidate(propertyListProvider),
                      ),
                    ),
                  ),
                ),

                // Loading More Indicator
                if (propertiesAsync.value?.hasMore ?? false)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFDA9C5F),
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // 3. Navbar
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Propiedades",
              onNavigateHome: () => context.go('/home'),
              onNavigateProperties: () => context.go('/properties'),
              onNavigateAbout: () => context.go('/about'),
              onNavigateProfile: () => context.go('/profile'),
              onNavigateNotifications: () => context.go('/notifications'),
              onNavigateContracts: () => context.go('/contracts'),
              onNavigatePayments: () => context.go('/payments'),
              onNavigateMaintenance: () => context.go('/maintenance'),
              onNavigateMyRequests: () => context.go('/requests'),
              onNavigateRequests: () => context.go('/requests'),
              onNavigateMyReports: () => context.go('/reports'),
              onNavigateSettings: () => context.go('/settings'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CinematicBackground extends StatelessWidget {
  const _CinematicBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D0A09),
            Color(0xFF1E1410),
            Color(0xFF2E1D17),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  const _SearchBar({required this.controller, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F0F), // Almost black
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFDA9C5F).withOpacity(0.4)), // More visible
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        style: const TextStyle(color: Color(0xFFF0E5DB), fontSize: 16),
        decoration: InputDecoration(
          hintText: "Buscar por ubicación o título...",
          hintStyle: TextStyle(color: const Color(0xFFF0E5DB).withOpacity(0.2)),
          prefixIcon:
              const Icon(Icons.search, color: Color(0xFFDA9C5F), size: 24),
          border: InputBorder.none,
          filled: false,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class _CreateActionButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CreateActionButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFDA9C5F), Color(0xFFB8791F)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDA9C5F).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.add, color: Color(0xFF1A0E0A), size: 20),
            SizedBox(width: 8),
            const Text(
              "Publicar",
              style: TextStyle(
                color: Color(0xFF1A0E0A),
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  final String selectedType;
  final Function(String) onSelected;
  const _FilterChips({required this.selectedType, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final types = ['Todos', 'Casas', 'Apartamentos', 'Oficinas', 'Locales'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: types.map((type) {
          final isSelected = selectedType == type;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (_) => onSelected(type),
              backgroundColor: const Color(0xFF241711),
              selectedColor: const Color(0xFFDA9C5F),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF1A0E0A) : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      isSelected ? Colors.transparent : const Color(0x26DA9C5F),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final Property property;
  const _PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    final imageUrl = property.propertyImages.isNotEmpty
        ? property.propertyImages.first.url
        : null;

    return GestureDetector(
      onTap: () => context.push('/properties/${property.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1513),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : const _PlaceholderImage(),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _StatusBadge(status: property.status ?? 'available'),
                  ),
                ],
              ),
            ),
            // Info Section
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        color: Color(0xFFF0E5DB),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Color(0xFFDA9C5F), size: 14),
                        const SizedBox(width: 4),
                        Text(
                          property.city,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, color: Colors.white10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Precio Mensual",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.3),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$${(property.price ?? 0).toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Color(0xFFDA9C5F),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        _InfoFeature(
                          icon: Icons.king_bed_outlined,
                          value: "${property.numBedrooms ?? 0}",
                        ),
                        _InfoFeature(
                          icon: Icons.bathtub_outlined,
                          value: "${property.numBathrooms ?? 0}",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AppActionButton(
                      text: "Ver Detalles",
                      onClick: () => context.push('/properties/${property.id}'),
                      gradient: const [Color(0xFF2E1D17), Color(0xFF1B130F)],
                      animationSeed: property.id,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color = const Color(0xFF27AE60);
    String text = "DISPONIBLE";

    if (status.toLowerCase().contains('rented')) {
      color = const Color(0xFFE74C3C);
      text = "RENTADO";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoFeature extends StatelessWidget {
  final IconData icon;
  final String value;
  const _InfoFeature({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.3), size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFF0E5DB),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.home_work_outlined,
            color: Colors.white.withOpacity(0.1), size: 80),
        const SizedBox(height: 16),
        const Text(
          "No se encontraron propiedades",
          style: TextStyle(
            color: Color(0xFFF0E5DB),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Intenta ajustar tus filtros de búsqueda.",
          style: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorState({required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_off, color: Color(0xFFE74C3C), size: 60),
        const SizedBox(height: 16),
        const Text(
          "Error de conexión",
          style: TextStyle(
            color: Color(0xFFF0E5DB),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onRetry,
          child: const Text(
            "Reintentar",
            style: TextStyle(color: Color(0xFFDA9C5F), fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF241711),
      child:
          const Icon(Icons.image_outlined, color: Color(0x33DA9C5F), size: 48),
    );
  }
}
