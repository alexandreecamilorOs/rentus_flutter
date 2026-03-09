import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/entity_providers.dart';
import '../../../data/models/property_model.dart';
import '../../components/home_navbar.dart';
import '../../components/animated_heading.dart';
import '../../components/app_action_button.dart';
import '../../components/modern_view_wrapper.dart';
import '../../components/modern_header.dart';
import '../../components/modern_drawer.dart';
import '../../components/upward_particles.dart';
import '../../components/map_mini_view.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyListProvider);

    return Scaffold(
      key: _scaffoldKey,
      onDrawerChanged: (isOpened) {
        setState(() => _isDrawerOpen = isOpened);
      },
      drawer: const ModernDrawer(),
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          // 1. Unified Cinematic Background
          const _UnifiedBackground(),

          // 2. Main Content
          RefreshIndicator(
            onRefresh: () => ref.refresh(propertyListProvider.future),
            color: const Color(0xFFDA9C5F),
            backgroundColor: const Color(0xFF17110E),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Removed from here to make it persistent
                // SliverToBoxAdapter(
                //   child: ModernHeader(
                //     isDrawerOpen: _isDrawerOpen,
                //     onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                //   ),
                // ),

                // Top Padding (Adjusted for Header)
                const SliverToBoxAdapter(child: SizedBox(height: 80)),

                // 3. Hero Section Luxury
                SliverToBoxAdapter(
                  child: _LuxuryHeroSection(
                    properties: propertyAsync.maybeWhen(
                      data: (state) => state.items,
                      orElse: () => [],
                    ),
                  ),
                ),

                // 4. Modern Search Bar
                const SliverToBoxAdapter(child: _ModernSearchSection()),

                // 5. Featured Properties Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0x1ADA9C5F),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0x33DA9C5F)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star,
                                  color: Color(0xFFDA9C5F), size: 14),
                              SizedBox(width: 8),
                              Text(
                                "PROPIEDADES DESTACADAS",
                                style: TextStyle(
                                  color: Color(0xFFDA9C5F),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const AnimatedHeading(
                          text: "Descubre tu próximo\nhogar exclusivo",
                          style: TextStyle(fontSize: 32, height: 1.1),
                          gradientColors: [
                            Color(0xFFFFE7C7),
                            Color(0xFFF6D2A5),
                            Color(0xFFDA9C5F),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // 6. Real-time Properties Grid/List
                propertyAsync.when(
                  data: (state) {
                    final items = state.items;
                    if (items.isEmpty) {
                      return const SliverToBoxAdapter(
                          child: _EmptyPropertiesState());
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _LuxuryPropertyCard(
                            property: items[index],
                            index: index,
                          ),
                          childCount: items.length > 5
                              ? 5
                              : items.length, // Limit on Home
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFDA9C5F))),
                    ),
                  ),
                  error: (e, _) => SliverToBoxAdapter(
                    child: _ErrorPropertiesState(
                        onRetry: () => ref.refresh(propertyListProvider)),
                  ),
                ),

                // 7. "View More" CTA
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 32),
                    child: AppActionButton(
                      text: "Explorar todas las propiedades",
                      onClick: () => context.go('/properties'),
                      gradient: const [Color(0xFF2E1D17), Color(0xFF3B251D)],
                    ),
                  ),
                ),

                // 8. Bottom CTA Section
                const SliverToBoxAdapter(child: _LuxuryCtaSection()),

                // Navigation Spacing
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),

          // Bottom Navbar
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Inicio",
              onNavigateHome: () => context.go('/home'),
              onNavigateProperties: () => context.go('/properties'),
              onNavigateMap: () => context.go('/map'),
              onNavigateProfile: () => context.go('/profile'),
              onNavigateNotifications: () => context.go('/notifications'),
              onNavigateContracts: () => context.go('/contracts'),
              onNavigatePayments: () => context.go('/payments'),
              onNavigateMaintenance: () => context.go('/maintenance'),
              onNavigateMyRequests: () => context.go('/owner_requests'),
              onNavigateRequests: () => context.go('/owner_requests'),
              onNavigateMyReports: () => context.go('/reports'),
              onNavigateSettings: () => context.go('/settings'),
            ),
          ),
          // 3. Fixed Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ModernHeader(
              isDrawerOpen: _isDrawerOpen,
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),
        ],
      ),
    ).modernWrapped();
  }
}

// --- Background Components (Shared with Profile) ---

class _UnifiedBackground extends StatelessWidget {
  const _UnifiedBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D0A09),
                Color(0xFF1E1410),
                Color(0xFF2E1D17),
              ],
            ),
          ),
        ),
        // Cinematic upward particles
        const UpwardParticles(),

        // Background Orbs for depth
        Positioned(
          top: -100,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFDA9C5F).withOpacity(0.08),
                  blurRadius: 100,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// --- Luxury Components ---

class _LuxuryHeroSection extends StatelessWidget {
  final List<Property> properties;
  const _LuxuryHeroSection({required this.properties});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Color(0xFFDA9C5F), size: 14),
                SizedBox(width: 8),
                Text(
                  "MODO CINEMÁTICO 2026",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Title
          const AnimatedHeading(
            text: "El hogar que sueñas\nse ve así de brutal",
            style: TextStyle(fontSize: 38, height: 1.05),
            gradientColors: [
              Color(0xFFFFE7C7),
              Color(0xFFF6D2A5),
              Color(0xFFDA9C5F),
              Color(0xFFB77A49),
            ],
            durationMillis: 3000,
          ),
          const SizedBox(height: 16),

          Text(
            "Experiencia inmersiva con cartas iluminadas, navegación premium y propiedades de otro nivel.",
            style: TextStyle(
              color: const Color(0xFFEFE8DD).withOpacity(0.8),
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Stats Inline
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _HeroStatItem(
                  icon: Icons.home_work_outlined,
                  value: properties.length > 0 ? "${properties.length}+" : "0",
                  label: "Propiedades",
                ),
                const SizedBox(width: 12),
                const _HeroStatItem(
                  icon: Icons.people_outline,
                  value: "950+",
                  label: "Clientes",
                ),
                const SizedBox(width: 12),
                const _HeroStatItem(
                  icon: Icons.verified_user_outlined,
                  value: "5★",
                  label: "Rating",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Map Preview Card with Floating Decorations
          Stack(
            clipBehavior: Clip.none,
            children: [
              MapMiniView(
                properties: properties,
                onTap: () => context.push('/map'),
              ),
              // Floating Card 1: Verified Properties
              const Positioned(
                top: -15,
                left: -10,
                child: _FloatingCard(
                  icon: Icons.home_rounded,
                  text: "Propiedades Verificadas",
                  delay: 0,
                ),
              ),
              // Floating Card 2: 5-Star Rating
              const Positioned(
                bottom: 25,
                right: -10,
                child: _FloatingCard(
                  icon: Icons.star_rounded,
                  text: "Calificación 5 Estrellas",
                  delay: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _HeroStatItem(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x0DFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1ADA9C5F)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFDA9C5F), size: 18),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Text(
                label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Removed _MapPreviewCard as it's replaced by MapMiniView ---

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.redAccent.withOpacity(0.5 + 0.5 * _controller.value),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withOpacity(0.5 * _controller.value),
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
        );
      },
    );
  }
}

class _ModernSearchSection extends StatelessWidget {
  const _ModernSearchSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF17110E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x26DA9C5F)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            const _SearchField(
              icon: Icons.search,
              hint: "Buscar por nombre o descripción...",
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _SearchField(
                    icon: Icons.location_city,
                    hint: "Ciudad",
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _SearchField(
                    icon: Icons.category_outlined,
                    hint: "Tipo",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppActionButton(
              text: "Buscar Propiedades",
              onClick: () {},
              gradient: const [Color(0xFFDA9C5F), Color(0xFFB8791F)],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final IconData icon;
  final String hint;

  const _SearchField({required this.icon, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF241711),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFDA9C5F), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              hint,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _LuxuryPropertyCard extends StatelessWidget {
  final Property property;
  final int index;

  const _LuxuryPropertyCard({required this.property, required this.index});

  @override
  Widget build(BuildContext context) {
    final imageUrl = property.propertyImages.isNotEmpty
        ? property.propertyImages.first.url
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B130F),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1ADA9C5F)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDA9C5F).withOpacity(0.03),
            blurRadius: 20,
            spreadRadius: -5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // Image Stack
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: imageUrl != null && imageUrl.isNotEmpty
                      ? Image.network(imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const _PlaceholderImage())
                      : const _PlaceholderImage(),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x99000000)],
                      ),
                    ),
                  ),
                ),
                // Badges
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 10)
                      ],
                    ),
                    child: Text(
                      property.status?.toUpperCase() ?? 'DISPONIBLE',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Price Tag
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "DESDE",
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${(property.price ?? 0).toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Color(0xFF2ECC71),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.title,
                              style: const TextStyle(
                                color: Color(0xFFF0E5DB),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFFDA9C5F), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  property.city,
                                  style: const TextStyle(
                                      color: Color(0xFFA0AEC0), fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Features
                  const Row(
                    children: [
                      _CompactFeature(icon: Icons.straighten, value: "120 m²"),
                      SizedBox(width: 12),
                      _CompactFeature(
                          icon: Icons.king_bed_outlined, value: "3"),
                      SizedBox(width: 12),
                      _CompactFeature(icon: Icons.bathtub_outlined, value: "2"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Action Button
                  AppActionButton(
                    text: "Ver Detalles",
                    onClick: () {}, // Navigate to Detail
                    gradient: const [Color(0xFF2E1D17), Color(0xFF1B130F)],
                    animationSeed: property.id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactFeature extends StatelessWidget {
  final IconData icon;
  final String value;
  const _CompactFeature({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFDA9C5F), size: 16),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
              color: Color(0xFFEFE8DD),
              fontSize: 13,
              fontWeight: FontWeight.w600),
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

class _EmptyPropertiesState extends StatelessWidget {
  const _EmptyPropertiesState();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(Icons.home_outlined, color: Color(0x33DA9C5F), size: 60),
          const SizedBox(height: 16),
          const Text(
            "No hay propiedades disponibles ahora",
            style: TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Vuelve más tarde para descubrir nuevas oportunidades.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}

class _ErrorPropertiesState extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorPropertiesState({required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 16),
          const Text(
            "Error al cargar propiedades",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onRetry,
            child: const Text("Intentar de nuevo",
                style: TextStyle(color: Color(0xFFDA9C5F))),
          ),
        ],
      ),
    );
  }
}

class _LuxuryCtaSection extends StatelessWidget {
  const _LuxuryCtaSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF2E1D17), Color(0xFF3B251D)],
          ),
          border: Border.all(color: const Color(0x33DA9C5F)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.star, color: Color(0xFFDA9C5F), size: 32),
            const SizedBox(height: 16),
            const Text(
              "¿Listo para encontrar tu próximo hogar?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Explora todas las propiedades o comunícate con nuestro equipo experto.",
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppActionButton(
                    text: "Ver propiedades",
                    onClick: () {},
                    gradient: const [Color(0xFFFFFFFF), Color(0xFFF1E6D7)],
                    contentColor: const Color(0xFF3B251D),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Icon(Icons.phone, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingCard extends StatefulWidget {
  final IconData icon;
  final String text;
  final double delay;

  const _FloatingCard({
    required this.icon,
    required this.text,
    this.delay = 0,
  });

  @override
  State<_FloatingCard> createState() => _FloatingCardState();
}

class _FloatingCardState extends State<_FloatingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -12)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -12, end: 0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_controller);

    Future.delayed(Duration(milliseconds: (widget.delay * 1000).toInt()), () {
      if (mounted) _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: const Color(0xFFDA9C5F), size: 18),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
