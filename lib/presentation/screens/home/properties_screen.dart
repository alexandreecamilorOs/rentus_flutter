import 'package:flutter/material.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';
import '../../components/home_navbar.dart';
import '../../animations/shimmer_block.dart';
import '../../components/modern_view_wrapper.dart';

class PropertyCardItem {
  final String title;
  final String city;
  final String price;
  final String area;
  final String bedrooms;
  final String bathrooms;
  final String status;
  final String badge;

  PropertyCardItem({
    required this.title,
    required this.city,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.status,
    required this.badge,
  });
}

enum PropertiesUiState { Loading, Error, Empty, Success }

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  String _query = "";
  String _selectedFilter = "Todas";
  int _carouselIndex = 0;

  final List<String> _filters = [
    "Todas",
    "Apartamento",
    "Casa",
    "Arriendo",
    "Venta",
    "Premium"
  ];
  final List<String> _featured = [
    "Penthouse Sky Lounge",
    "Villa Designer 2026",
    "Loft Smart Living"
  ];
  final List<PropertyCardItem> _properties = [
    PropertyCardItem(
        title: "Penthouse Sky Lounge",
        city: "Medellín",
        price: "\$6.200.000 / mes",
        area: "220m²",
        bedrooms: "4 hab",
        bathrooms: "4 baños",
        status: "Disponible",
        badge: "TOP"),
    PropertyCardItem(
        title: "Villa Lake Side",
        city: "Rionegro",
        price: "\$1.250.000.000",
        area: "420m²",
        bedrooms: "5 hab",
        bathrooms: "6 baños",
        status: "Venta",
        badge: "NEW"),
    PropertyCardItem(
        title: "Loft Neon District",
        city: "Bogotá",
        price: "\$3.100.000 / mes",
        area: "92m²",
        bedrooms: "2 hab",
        bathrooms: "2 baños",
        status: "Disponible",
        badge: "HOT"),
    PropertyCardItem(
        title: "Casa Forest Minimal",
        city: "Cali",
        price: "\$4.700.000 / mes",
        area: "260m²",
        bedrooms: "4 hab",
        bathrooms: "4 baños",
        status: "Nuevo",
        badge: "TREND"),
  ];

  @override
  void initState() {
    super.initState();
    _startCarouselTimer();
  }

  void _startCarouselTimer() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 3200));
      if (mounted) {
        setState(() {
          _carouselIndex = (_carouselIndex + 1) % _featured.length;
        });
      }
    }
  }

  PropertiesUiState get _uiState {
    if (_query.toLowerCase() == "loading") return PropertiesUiState.Loading;
    if (_query.toLowerCase() == "error") return PropertiesUiState.Error;
    if (_query.toLowerCase() == "empty") return PropertiesUiState.Empty;
    return PropertiesUiState.Success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D0A09),
                  Color(0xFF241711),
                  Color(0xFF3B251D)
                ],
              ),
            ),
          ),
          const FuturisticBackground(),
          SafeArea(
            bottom: false,
            child: _buildContent(),
          ),
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
    ).modernWrapped();
  }

  Widget _buildContent() {
    switch (_uiState) {
      case PropertiesUiState.Loading:
        return const _LoadingState();
      case PropertiesUiState.Error:
        return _CenterInfo(
          message: "No pudimos cargar las propiedades.",
          child: AppActionButton(
            text: "Reintentar",
            onClick: () {},
          ),
        );
      case PropertiesUiState.Empty:
        return const _CenterInfo(
          message: "No encontramos resultados para tu búsqueda.",
          child:
              Icon(Icons.hourglass_bottom, color: Color(0xFFDA9C5F), size: 30),
        );
      case PropertiesUiState.Success:
        return ListView(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
          children: [
            const _HeroBlock(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: AppActionButton(
                        text: "Crear",
                        onClick: () => context.go('/properties/create'),
                        gradient: const [
                      Color(0xFFDA9C5F),
                      Color(0xFFB8791F),
                      Color(0xFFDA9C5F)
                    ])),
                const SizedBox(width: 8),
                Expanded(
                    child: AppActionButton(
                        text: "Detalle",
                        onClick: () => context.go('/properties/detail'),
                        gradient: const [
                      Color(0xFF6366F1),
                      Color(0xFF4F46E5),
                      Color(0xFF6366F1)
                    ])),
                const SizedBox(width: 8),
                Expanded(
                    child: AppActionButton(
                        text: "Editar",
                        onClick: () => context.go('/properties/edit'),
                        gradient: const [
                      Color(0xFF22C55E),
                      Color(0xFF16A34A),
                      Color(0xFF22C55E)
                    ])),
              ],
            ),
            const SizedBox(height: 12),
            _PropertyCarousel(
              title: _featured[_carouselIndex],
              index: _carouselIndex,
              count: _featured.length,
              onPrev: () => setState(() => _carouselIndex =
                  (_carouselIndex - 1 + _featured.length) % _featured.length),
              onNext: () => setState(() =>
                  _carouselIndex = (_carouselIndex + 1) % _featured.length),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: "Busca por ciudad, tipo o mood de vivienda",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF241711),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: Colors.white),
              onChanged: (val) => setState(() => _query = val),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter,
                          style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFF1A0E0A)
                                  : const Color(0xFFF0E5DB))),
                      selected: isSelected,
                      onSelected: (val) =>
                          setState(() => _selectedFilter = filter),
                      selectedColor: const Color(0xFFDA9C5F),
                      backgroundColor: const Color(0x1FFFFFFF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "${_properties.length} propiedades premium encontradas",
              style: const TextStyle(
                  color: Color(0xFFE8DAC8),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: _properties.length,
              itemBuilder: (context, index) {
                return _PropertyCard(
                    property: _properties[index],
                    index: index,
                    onClick: () => context.go('/properties/detail'));
              },
            ),
          ],
        );
    }
  }
}

class FuturisticBackground extends StatefulWidget {
  const FuturisticBackground({super.key});

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
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
        return Stack(
          children: List.generate(18, (i) {
            final shift = _controller.value * -24.0;
            return Positioned(
              left: 20.0 + i * 20.0,
              top: 40.0 + i * 45.0 + shift,
              child: Container(
                width: 3.0 + i % 3,
                height: 3.0 + i % 3,
                decoration: const BoxDecoration(
                  color: Color(0x44DA9C5F),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _CenterInfo extends StatelessWidget {
  final String message;
  final Widget child;

  const _CenterInfo({required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 10),
          Text(message,
              style: const TextStyle(
                  color: Color(0xFFF0E5DB), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          const ShimmerBlock(height: 220),
          const SizedBox(height: 12),
          const ShimmerBlock(height: 52),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: ShimmerBlock(height: 36)),
              const SizedBox(width: 8),
              const Expanded(child: ShimmerBlock(height: 36)),
              const SizedBox(width: 8),
              const Expanded(child: ShimmerBlock(height: 36)),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children:
                  List.generate(4, (index) => const ShimmerBlock(height: 120)),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x223B251D),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.auto_awesome, color: Color(0xFFDA9C5F), size: 20),
              SizedBox(width: 6),
              Text("Colección 2026",
                  style: TextStyle(
                      color: Color(0xFFDA9C5F), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const AnimatedHeading(
              text: "Propiedades 2026 • Motion UI",
              style: TextStyle(fontSize: 30, height: 1.1)),
          const SizedBox(height: 8),
          const Text(
            "Explora un look futurista: microanimaciones, brillo premium y flujo directo a crear/detalle/edición.",
            style: TextStyle(color: Color(0xFFE8DAC8), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _PropertyCarousel extends StatelessWidget {
  final String title;
  final int index;
  final int count;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _PropertyCarousel({
    required this.title,
    required this.index,
    required this.count,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade900,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Center(
              child: Icon(Icons.image, size: 48, color: Colors.white24)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0xB0000000),
                  Color(0xD90D0A09)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 14,
            left: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.star, color: Color(0xFFF6D2A5), size: 14),
                    SizedBox(width: 4),
                    Text("Featured Drop",
                        style: TextStyle(
                            color: Color(0xFFF6D2A5),
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
                AnimatedHeading(
                    text: title,
                    style: const TextStyle(fontSize: 18),
                    gradientColors: const [
                      Color(0xFFFFF7EE),
                      Color(0xFFF6D2A5),
                      Color(0xFFDA9C5F)
                    ],
                    durationMillis: 3100),
                Text("${index + 1} / $count",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), fontSize: 12)),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: Row(
              children: [
                _GlassArrow(icon: Icons.chevron_left, onClick: onPrev),
                const SizedBox(width: 8),
                _GlassArrow(icon: Icons.chevron_right, onClick: onNext),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;

  const _GlassArrow({required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final PropertyCardItem property;
  final int index;
  final VoidCallback onClick;

  const _PropertyCard(
      {required this.property, required this.index, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E140F),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade900,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Center(child: Icon(Icons.image, color: Colors.white24)),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color(0xCC0D0A09),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(property.badge,
                          style: const TextStyle(
                              color: Color(0xFFDA9C5F),
                              fontSize: 10,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color(0xCC2ECC71),
                          borderRadius: BorderRadius.circular(50)),
                      child: Text(property.status,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AnimatedHeading(
                text: property.title,
                style: const TextStyle(fontSize: 14),
                gradientColors: const [
                  Color(0xFFFFF4E8),
                  Color(0xFFF6D2A5),
                  Color(0xFFDA9C5F)
                ],
                durationMillis: 3000),
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Color(0xFFDA9C5F), size: 14),
                Text(property.city,
                    style: const TextStyle(
                        color: Color(0xFFBCA99A), fontSize: 12)),
              ],
            ),
            Text(property.price,
                style: const TextStyle(
                    color: Color(0xFF2ECC71),
                    fontWeight: FontWeight.w900,
                    fontSize: 12)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _MiniFeature(icon: Icons.apartment, text: property.area),
                _MiniFeature(icon: Icons.bed, text: property.bedrooms),
                _MiniFeature(icon: Icons.bathtub, text: property.bathrooms),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniFeature extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MiniFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x33DA9C5F),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFDA9C5F), size: 12),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(fontSize: 10, color: Color(0xFFE7D8C8))),
        ],
      ),
    );
  }
}
