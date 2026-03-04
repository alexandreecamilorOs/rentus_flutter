import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/providers/entity_providers.dart';
import '../../../data/models/property_model.dart';
import '../../components/app_action_button.dart';
import '../../../data/providers/auth_provider.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  final int propertyId;
  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  int _currentImageIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(propertyDetailProvider(widget.propertyId));

    return Scaffold(
      backgroundColor: const Color(0xFF1A0E0A),
      body: Stack(
        children: [
          // 1. Cinematic Background
          const _CinematicBackground(),

          // 2. Main Content
          detailAsync.when(
            data: (property) => _buildContent(context, property),
            loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFFDA9C5F)),
            ),
            error: (err, _) => _buildError(context, err.toString()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Property property) {
    final images = property.propertyImages.map((e) => e.url).toList();
    if (images.isEmpty) {
      images.add('https://via.placeholder.com/1200x600?text=Sin+Imagen');
    }

    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Breadcrumb
          SliverToBoxAdapter(
            child: _Breadcrumb(title: property.title),
          ),

          // Gallery
          SliverToBoxAdapter(
            child: _Gallery(
              images: images,
              currentIndex: _currentImageIndex,
              onIndexChanged: (index) =>
                  setState(() => _currentImageIndex = index),
              status: property.status ?? 'available',
            ),
          ),

          // Main Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth > 900;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PropertyHeader(property: property),
                            const SizedBox(height: 20),
                            _PriceBanner(property: property),
                            const SizedBox(height: 24),
                            _FeaturesGrid(property: property),
                            const SizedBox(height: 24),
                            _DescriptionSection(
                                description: property.description),
                            const SizedBox(height: 24),
                            // Map placeholder for now or integrated MapView if available
                            _MapSection(property: property),
                          ],
                        ),
                      ),
                      if (isDesktop) const SizedBox(width: 24),
                      // Sidebar (Only if desktop)
                      if (isDesktop)
                        SizedOverflowBox(
                          size: const Size(340, 0),
                          alignment: Alignment.topCenter,
                          child: _Sidebar(property: property),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Sidebar for Mobile/Tablet
          SliverToBoxAdapter(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth <= 900) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: _Sidebar(property: property),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 60)),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE74C3C), size: 64),
          const SizedBox(height: 16),
          Text(
            "Propiedad no encontrada",
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error, style: TextStyle(color: Colors.white.withOpacity(0.5))),
          const SizedBox(height: 24),
          AppActionButton(
            text: "Volver al Inicio",
            onClick: () => context.go('/home'),
            width: 200,
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
          colors: [Color(0xFF1A0E0A), Color(0xFF2E1D17), Color(0xFF3B2416)],
        ),
      ),
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final String title;
  const _Breadcrumb({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFFDA9C5F), size: 20),
            onPressed: () => context.pop(),
          ),
          const Icon(Icons.home_outlined, color: Colors.white30, size: 16),
          const Icon(Icons.chevron_right, color: Colors.white12, size: 14),
          GestureDetector(
            onTap: () => context.go('/properties'),
            child: const Text("Propiedades",
                style: TextStyle(color: Colors.white30, fontSize: 13)),
          ),
          const Icon(Icons.chevron_right, color: Colors.white12, size: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  color: Color(0xFFDA9C5F),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final Function(int) onIndexChanged;
  final String status;

  const _Gallery({
    required this.images,
    required this.currentIndex,
    required this.onIndexChanged,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 400,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withOpacity(0.4),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  images[currentIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.white24),
                ),
              ),
              // Nav Buttons
              if (images.length > 1)
                Positioned.fill(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _NavBtn(
                        icon: Icons.chevron_left,
                        onTap: currentIndex > 0
                            ? () => onIndexChanged(currentIndex - 1)
                            : null,
                      ),
                      _NavBtn(
                        icon: Icons.chevron_right,
                        onTap: currentIndex < images.length - 1
                            ? () => onIndexChanged(currentIndex + 1)
                            : null,
                      ),
                    ],
                  ),
                ),
              // Counter
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.image_outlined,
                          color: Colors.white70, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        "${currentIndex + 1} / ${images.length}",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              // Status
              Positioned(
                top: 16,
                left: 16,
                child: _StatusBadge(status: status),
              ),
            ],
          ),
        ),
        // Thumbnails
        if (images.length > 1)
          Container(
            height: 60,
            margin: const EdgeInsets.only(top: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: images.length,
              itemBuilder: (context, index) {
                final isSelected = index == currentIndex;
                return GestureDetector(
                  onTap: () => onIndexChanged(index),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFDA9C5F)
                            : Colors.white12,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(images[index], fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _NavBtn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: IconButton(
        onPressed: onTap,
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
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
    final bool isAvailable = status == 'available';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable
            ? const Color(0xFF27AE60).withOpacity(0.2)
            : const Color(0xFFE74C3C).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isAvailable
                ? const Color(0xFF2ecc71).withOpacity(0.4)
                : const Color(0xFFe74c3c).withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isAvailable ? Icons.check_circle : Icons.cancel,
              color: isAvailable
                  ? const Color(0xFF2ecc71)
                  : const Color(0xFFe74c3c),
              size: 14),
          const SizedBox(width: 6),
          Text(
            isAvailable ? "DISPONIBLE" : status.toUpperCase(),
            style: TextStyle(
                color: isAvailable
                    ? const Color(0xFF2ecc71)
                    : const Color(0xFFe74c3c),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }
}

class _PropertyHeader extends StatelessWidget {
  final Property property;
  const _PropertyHeader({required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _Tag(
                text: property.type?.toUpperCase() ?? "OTRO",
                color: const Color(0xFFDA9C5F)),
            const SizedBox(width: 8),
            const _Tag(text: "NUEVO", color: Color(0xFFa5b4fc)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          property.title,
          style: const TextStyle(
              color: Color(0xFFF0E5DB),
              fontSize: 32,
              fontWeight: FontWeight.w800,
              height: 1.2),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.location_on, color: Color(0xFFDA9C5F), size: 18),
            const SizedBox(width: 6),
            Text(
              "${property.address ?? '-'}, ${property.city}",
              style:
                  TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color color;
  const _Tag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _PriceBanner extends StatelessWidget {
  final Property property;
  const _PriceBanner({required this.property});

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'es_CO', symbol: r'$', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFDA9C5F).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDA9C5F).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PRECIO MENSUAL",
                    style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
                Text(
                  currency.format(property.price ?? 0),
                  style: const TextStyle(
                      color: Color(0xFFDA9C5F),
                      fontSize: 28,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          Container(height: 40, width: 1, color: Colors.white12),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("DEPÓSITO",
                    style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1)),
                Text(
                  currency
                      .format((property.price ?? 0) * 0.5), // Simulated deposit
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  final Property property;
  const _FeaturesGrid({required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CARACTERÍSTICAS PRINCIPALES",
            style: TextStyle(
                color: Color(0xFFDA9C5F),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _FeatureItem(
                icon: Icons.square_foot,
                value: "${property.area?.toStringAsFixed(0) ?? '-'} m²",
                label: "Área Total"),
            _FeatureItem(
                icon: Icons.king_bed_outlined,
                value: "${property.numBedrooms ?? 0}",
                label: "Habitaciones"),
            _FeatureItem(
                icon: Icons.bathtub_outlined,
                value: "${property.numBathrooms ?? 0}",
                label: "Baños"),
            const _FeatureItem(
                icon: Icons.directions_car_outlined,
                value: "1",
                label: "Parqueos"),
          ],
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _FeatureItem(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFFDA9C5F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: const Color(0xFFDA9C5F), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text(label,
                  style: const TextStyle(color: Colors.white30, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String description;
  const _DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("DESCRIPCIÓN",
            style: TextStyle(
                color: Color(0xFFDA9C5F),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
        const SizedBox(height: 12),
        Text(
          description.isEmpty ? "Sin descripción disponible." : description,
          style: TextStyle(
              color: Colors.white.withOpacity(0.6), fontSize: 15, height: 1.6),
        ),
      ],
    );
  }
}

class _MapSection extends StatelessWidget {
  final Property property;
  const _MapSection({required this.property});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("UBICACIÓN",
            style: TextStyle(
                color: Color(0xFFDA9C5F),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            color: Colors.black26,
            image: const DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1000&auto=format&fit=crop"),
              fit: BoxFit.cover,
              opacity: 0.4,
            ),
          ),
          child: const Center(
            child: Icon(Icons.location_on, color: Color(0xFFDA9C5F), size: 40),
          ),
        ),
      ],
    );
  }
}

class _Sidebar extends ConsumerWidget {
  final Property property;
  const _Sidebar({required this.property});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isOwner = authState.user?.id == property.userId;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3E2418), Color(0xFF2E1D17)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDA9C5F).withOpacity(0.25)),
        boxShadow: const [
          BoxShadow(
              color: Colors.black54,
              blurRadius: 30,
              offset: Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isOwner) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFFDA9C5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFDA9C5F).withOpacity(0.3))),
              child: const Row(children: [
                Icon(Icons.auto_awesome, color: Color(0xFFDA9C5F), size: 18),
                SizedBox(width: 8),
                Text("Eres el dueño",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F), fontWeight: FontWeight.bold))
              ]),
            ),
            const SizedBox(height: 16),
            AppActionButton(
                text: "Editar Propiedad",
                icon: Icons.edit,
                onClick: () => context.push('/properties/${property.id}/edit'),
                gradient: const [Color(0xFFDA9C5F), Color(0xFFB8791F)]),
            const SizedBox(height: 12),
            AppActionButton(
                text: "Eliminar",
                icon: Icons.delete_outline,
                onClick: () {},
                gradient: const [Color(0xFFE74C3C), Color(0xFFC0392B)]),
          ] else ...[
            const Text("¿Te interesa esta propiedad?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Inicia una conversación con el dueño ahora mismo.",
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 13)),
            const SizedBox(height: 24),
            AppActionButton(
                text: "Solicitar Visita",
                icon: Icons.calendar_today,
                onClick: () {},
                gradient: const [Color(0xFFDA9C5F), Color(0xFFB8791F)]),
            const SizedBox(height: 12),
            AppActionButton(
                text: "Contactar Agente",
                icon: Icons.phone,
                onClick: () {},
                gradient: const [Color(0xFF2E1D17), Color(0xFF1B130F)]),
          ],
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 20),
          const _MetaRow(icon: Icons.access_time, label: "Publicado hace 2 días"),
          const SizedBox(height: 12),
          const _MetaRow(
              icon: Icons.remove_red_eye_outlined,
              label: "124 visualizaciones"),
          const SizedBox(height: 12),
          _MetaRow(icon: Icons.tag, label: "ID de propiedad: ${property.id}"),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white24, size: 16),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(color: Colors.white30, fontSize: 12)),
      ],
    );
  }
}
