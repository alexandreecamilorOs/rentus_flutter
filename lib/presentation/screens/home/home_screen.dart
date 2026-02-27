import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/animated_heading.dart';
import '../../components/app_action_button.dart';
import 'package:go_router/go_router.dart';

class DemoProperty {
  final String title;
  final String city;
  final String price;
  final String area;
  final String bedrooms;
  final String bathrooms;
  final String status;

  DemoProperty({
    required this.title,
    required this.city,
    required this.price,
    required this.area,
    required this.bedrooms,
    required this.bathrooms,
    required this.status,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = [
      DemoProperty(
        title: "Penthouse Sky Lounge",
        city: "Bogotá",
        price: "\$6.200.000",
        area: "220m²",
        bedrooms: "4",
        bathrooms: "4",
        status: "Disponible",
      ),
      DemoProperty(
        title: "Casa Forest Minimal",
        city: "Medellín",
        price: "\$4.700.000",
        area: "260m²",
        bedrooms: "4",
        bathrooms: "4",
        status: "Top",
      ),
      DemoProperty(
        title: "Loft Neon District",
        city: "Cali",
        price: "\$3.100.000",
        area: "92m²",
        bedrooms: "2",
        bathrooms: "2",
        status: "Nuevo",
      ),
    ];

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
          const CinematicParticlesBackground(),
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 84),
            child: Column(
              children: [
                const SafeArea(child: SizedBox(height: 10)),
                const HeroSection(),
                const SearchSection(),
                PropertiesSection(properties: properties),
                const CtaSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Inicio",
              onNavigateHome: () => context.go('/home'),
              onNavigateProperties: () => context.go('/properties'),
              onNavigateAbout: () => context.go('/about'),
              onNavigateProfile: () => context.go('/profile'),
              onNavigateNotifications: () => context.go('/notifications'),
              onNavigateContracts: () => context.go('/contracts'),
              onNavigatePayments: () => context.go('/payments'),
              onNavigateMaintenance: () => context.go('/maintenance'),
              onNavigateMyRequests: () => context.go(
                  '/requests'), // Redirigiendo a requests genérico por ahora
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

class CinematicParticlesBackground extends StatefulWidget {
  const CinematicParticlesBackground({super.key});

  @override
  State<CinematicParticlesBackground> createState() =>
      _CinematicParticlesBackgroundState();
}

class _CinematicParticlesBackgroundState
    extends State<CinematicParticlesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
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
        return CustomPaint(
          painter: _ParticlesPainter(phase: _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double phase;
  _ParticlesPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paintA = Paint()..style = PaintingStyle.fill;
    final paintB = Paint()..style = PaintingStyle.fill;

    double ya = phase * -280;
    double yb = phase * -360;

    for (int i = 0; i < 84; i++) {
      double x = (i * 53) % w;
      double yBase = ((i * 97) % h) + 120;
      double y = yBase + ya;
      if (y < -40) y += h + 200;

      paintA.color =
          i % 3 == 0 ? const Color(0x66DA9C5F) : const Color(0x33F6D2A5);
      canvas.drawCircle(Offset(x, y), 2.0 + (i % 4), paintA);
    }

    for (int i = 0; i < 56; i++) {
      double x = (i * 71 + 32) % w;
      double yBase = ((i * 113) % h) + 180;
      double y = yBase + yb;
      if (y < -40) y += h + 240;

      paintB.color = Colors.white.withOpacity(0.18);
      canvas.drawCircle(Offset(x, y), 1.4 + (i % 3), paintB);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: GlowingSurface(
        corner: 24,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E1D17), Color(0xFF3B251D), Color(0xFF4D2F24)],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Color(0xFFC8A97E), size: 14),
                    SizedBox(width: 6),
                    Text(
                      "Modo Cinemático 2026",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const AnimatedHeading(
                text: "El hogar que sueñas\nse ve así de brutal",
                style: TextStyle(fontSize: 34, height: 1.05),
                gradientColors: [
                  Color(0xFFFFE7C7),
                  Color(0xFFF6D2A5),
                  Color(0xFFDA9C5F),
                  Color(0xFFB77A49),
                ],
                durationMillis: 2900,
              ),
              const SizedBox(height: 12),
              Text(
                "Experiencia inmersiva con cards iluminadas, navegación premium y propiedades de otro nivel.",
                style: TextStyle(
                  color: const Color(0xFFEFE8DD).withOpacity(0.92),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  _StatChip(
                      number: "1,200+", label: "Propiedades", icon: Icons.home),
                  SizedBox(width: 10),
                  _StatChip(
                      number: "980+",
                      label: "Clientes",
                      icon: Icons.check_circle),
                  SizedBox(width: 10),
                  _StatChip(number: "5⭐", label: "Rating", icon: Icons.star),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey.shade800, // Placeholder
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                        child: Icon(Icons.image,
                            size: 64, color: Colors.white.withOpacity(0.5))),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xB0000000)],
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 12,
                      left: 12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tour en vivo",
                              style: TextStyle(
                                  color: Color(0xFFF6D2A5),
                                  fontWeight: FontWeight.bold)),
                          Text("Explorar en mapa",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text("En vivo",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String number;
  final String label;
  final IconData icon;

  const _StatChip({
    required this.number,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFC8A97E), size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Text(label,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85), fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 2),
      child: GlowingSurface(
        corner: 18,
        child: Container(
          width: double.infinity,
          color: const Color(0xFF17110E),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Buscar propiedades",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFFF0E5DB))),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF241711),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Ciudad",
                    style: TextStyle(color: Color(0xFFBFAF9F), fontSize: 13)),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF241711),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Tipo",
                    style: TextStyle(color: Color(0xFFBFAF9F), fontSize: 13)),
              ),
              const SizedBox(height: 10),
              AppActionButton(
                text: "Buscar",
                onClick: () {},
                gradient: const [
                  Color(0xFF3B251D),
                  Color(0xFF2E1D17),
                  Color(0xFFDA9C5F)
                ],
                animationSeed: 101,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PropertiesSection extends StatelessWidget {
  final List<DemoProperty> properties;

  const PropertiesSection({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnimatedHeading(
            text: "Propiedades destacadas",
            style: TextStyle(fontSize: 26),
            gradientColors: [
              Color(0xFFFFE7C7),
              Color(0xFFF6D2A5),
              Color(0xFFDA9C5F)
            ],
            durationMillis: 2800,
          ),
          const SizedBox(height: 4),
          const Text(
              "Cartas con borde iluminado y volumen para una experiencia premium.",
              style: TextStyle(color: Color(0xFFE8DAC8))),
          const SizedBox(height: 12),
          ...properties.map((prop) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlowingSurface(
                corner: 18,
                child: Container(
                  color: const Color(0xFF1B130F),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 170,
                        width: double.infinity,
                        color: Colors.grey.shade800,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Center(
                                child: Icon(Icons.image,
                                    size: 48,
                                    color: Colors.white.withOpacity(0.5))),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0x77000000)
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF27AE60),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(prop.status,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AnimatedHeading(
                                        text: prop.title,
                                        style: const TextStyle(fontSize: 18),
                                        gradientColors: const [
                                          Color(0xFFFFF4E8),
                                          Color(0xFFF6D2A5),
                                          Color(0xFFDA9C5F)
                                        ],
                                        durationMillis: 3000,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Color(0xFFDA9C5F),
                                              size: 14),
                                          const SizedBox(width: 4),
                                          Text(prop.city,
                                              style: const TextStyle(
                                                  color: Color(0xFFBCA99A),
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Text(prop.price,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF2ECC71),
                                        fontSize: 18)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _FeatureMini(
                                    icon: Icons.apartment, value: prop.area),
                                const SizedBox(width: 8),
                                _FeatureMini(
                                    icon: Icons.bed, value: prop.bedrooms),
                                const SizedBox(width: 8),
                                _FeatureMini(
                                    icon: Icons.bathtub, value: prop.bathrooms),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AppActionButton(
                              text: "Ver detalles",
                              onClick: () {},
                              gradient: const [
                                Color(0xFF4D2F24),
                                Color(0xFF5D3A2D),
                                Color(0xFFDA9C5F)
                              ],
                              animationSeed: prop.title.hashCode,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _FeatureMini extends StatelessWidget {
  final IconData icon;
  final String value;

  const _FeatureMini({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A1C16),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFDA9C5F), size: 13),
          const SizedBox(width: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFE7D8C8),
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      child: GlowingSurface(
        corner: 22,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2E1D17), Color(0xFF3B251D)],
            ),
          ),
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Icon(Icons.star, color: Color(0xFFC8A97E), size: 32),
              const SizedBox(height: 8),
              const AnimatedHeading(
                text: "¿Listo para encontrar tu próximo hogar?",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
                gradientColors: [
                  Color(0xFFFFEED7),
                  Color(0xFFF6D2A5),
                  Color(0xFFC8A97E)
                ],
                durationMillis: 2800,
              ),
              const SizedBox(height: 8),
              Text(
                "Explora todas las propiedades o comunícate con nuestro equipo.",
                style: TextStyle(color: Colors.white.withOpacity(0.9)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              AppActionButton(
                text: "Ver propiedades",
                onClick: () {},
                contentColor: const Color(0xFF3B251D),
                gradient: const [
                  Color(0xFFFFFFFF),
                  Color(0xFFF1E6D7),
                  Color(0xFFFFFFFF)
                ],
                animationSeed: 707,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GlowingSurface extends StatelessWidget {
  final Widget child;
  final double corner;

  const GlowingSurface({super.key, required this.child, required this.corner});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(corner),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x55DA9C5F),
            Color(0x229B6C45),
            Color(0x44F6D2A5),
            Color(0x33906A49),
          ],
        ),
      ),
      padding: const EdgeInsets.all(1.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(corner - 1.5),
        child: child,
      ),
    );
  }
}
