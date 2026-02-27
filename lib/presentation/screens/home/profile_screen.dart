import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';
import '../../components/modern_view_wrapper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {"value": "12", "label": "Propiedades"},
      {"value": "98%", "label": "Respuesta"},
      {"value": "4.9", "label": "Rating"},
    ];

    final contactInfo = [
      {"label": "Correo", "value": "juan.rentus@email.com", "icon": Icons.mail},
      {"label": "Teléfono", "value": "+57 315 000 1111", "icon": Icons.phone},
      {
        "label": "Ubicación",
        "value": "Bogotá, Colombia",
        "icon": Icons.location_on
      },
    ];

    final properties = [
      {
        "title": "Apartamento Premium",
        "price": "\$2.500.000",
        "status": "Disponible"
      },
      {
        "title": "Casa Moderna Familiar",
        "price": "\$3.100.000",
        "status": "Disponible"
      },
      {
        "title": "Loft Ejecutivo",
        "price": "\$1.900.000",
        "status": "Mantenimiento"
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0605),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A0605),
                  Color(0xFF1A0E0A),
                  Color(0xFF2E1D17)
                ],
              ),
            ),
          ),
          const _ProfileAnimatedBackground(),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.only(
                  left: 18, right: 18, top: 16, bottom: 100),
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0x1AFFFFFF),
                      borderRadius: BorderRadius.circular(24)),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const _AvatarRings(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const AnimatedHeading(
                              text: "Juan RentUs",
                              style: TextStyle(fontSize: 30, height: 1.1)),
                          const SizedBox(width: 6),
                          const Icon(Icons.check_circle,
                              color: Color(0xFF3B82F6), size: 22),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text("@juan.rentus",
                          style: TextStyle(color: Color(0xFFA0AEC0))),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                            color: const Color(0x22DA9C5F),
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on,
                                color: Color(0xFFDA9C5F), size: 16),
                            const SizedBox(width: 6),
                            const Text("Bogotá, Cundinamarca",
                                style: TextStyle(
                                    color: Color(0xFFDA9C5F),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Asesor inmobiliario premium. Te ayudo a conseguir el hogar ideal con una experiencia clara, rápida y confiable.",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFFE7DDD1), fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: stats.map((stat) {
                          return Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: const Color(0x14FFFFFF),
                                    borderRadius: BorderRadius.circular(14)),
                                child: Column(
                                  children: [
                                    Text(stat['value'] as String,
                                        style: const TextStyle(
                                            color: Color(0xFFDA9C5F),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900)),
                                    Text(stat['label'] as String,
                                        style: const TextStyle(
                                            color: Color(0xFFA0AEC0),
                                            fontSize: 11)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      AppActionButton(
                        text: "Editar perfil",
                        onClick: () {},
                        gradient: const [
                          Color(0xFFDA9C5F),
                          Color(0xFFB8791F),
                          Color(0xFFDA9C5F)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...contactInfo.map((info) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0x12FFFFFF),
                            borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                  color: const Color(0x1FDA9C5F),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Icon(info['icon'] as IconData,
                                  color: const Color(0xFFDA9C5F)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(info['label'] as String,
                                    style: const TextStyle(
                                        color: Color(0xFFA0AEC0),
                                        fontSize: 11)),
                                Text(info['value'] as String,
                                    style: const TextStyle(
                                        color: Color(0xFFF0E5DB),
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0x12FFFFFF),
                      borderRadius: BorderRadius.circular(18)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AnimatedHeading(
                          text: "Mis Propiedades",
                          style: TextStyle(fontSize: 20),
                          gradientColors: [
                            Color(0xFFFFF4E8),
                            Color(0xFFF6D2A5),
                            Color(0xFFDA9C5F)
                          ],
                          durationMillis: 2800),
                      const SizedBox(height: 10),
                      ...properties.map((prop) {
                        final isAvail = prop['status'] == 'Disponible';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF21150F),
                                borderRadius: BorderRadius.circular(14)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 140,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(14),
                                          topRight: Radius.circular(14))),
                                  child: const Icon(Icons.apartment,
                                      size: 48, color: Colors.white24),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AnimatedHeading(
                                                text: prop['title'] as String,
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                gradientColors: const [
                                                  Color(0xFFFFF4E8),
                                                  Color(0xFFF6D2A5),
                                                  Color(0xFFDA9C5F)
                                                ],
                                                durationMillis: 3000),
                                            Text(prop['price'] as String,
                                                style: const TextStyle(
                                                    color: Color(0xFF2ECC71),
                                                    fontWeight:
                                                        FontWeight.w900)),
                                          ],
                                        ),
                                      ),
                                      Text(prop['status'] as String,
                                          style: TextStyle(
                                              color: isAvail
                                                  ? const Color(0xFF2ECC71)
                                                  : const Color(0xFFF39C12),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11)),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: [
                                      _ProfileChip(
                                          icon: Icons.apartment, text: "95m²"),
                                      _ProfileChip(icon: Icons.bed, text: "3"),
                                      _ProfileChip(
                                          icon: Icons.bathtub, text: "2"),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Icons.home, Icons.star, Icons.phone].map((icon) {
                    return Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                          color: const Color(0x1FDA9C5F),
                          borderRadius: BorderRadius.circular(14)),
                      child: Icon(icon, color: const Color(0xFFDA9C5F)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Perfil",
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
          )
        ],
      ),
    ).modernWrapped();
  }
}

class _ProfileAnimatedBackground extends StatefulWidget {
  const _ProfileAnimatedBackground();
  @override
  State<_ProfileAnimatedBackground> createState() =>
      _ProfileAnimatedBackgroundState();
}

class _ProfileAnimatedBackgroundState extends State<_ProfileAnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3600))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Stack(
          children: List.generate(20, (i) {
            final shift = _ctrl.value * -16.0;
            return Positioned(
              left: (i * 18.0),
              top: 50.0 + (i * 35.0) + shift,
              child: Container(
                width: 3.0 + i % 2,
                height: 3.0 + i % 2,
                decoration: const BoxDecoration(
                    color: Color(0x99DA9C5F), shape: BoxShape.circle),
              ),
            );
          }),
        );
      },
    );
  }
}

class _AvatarRings extends StatefulWidget {
  const _AvatarRings();
  @override
  State<_AvatarRings> createState() => _AvatarRingsState();
}

class _AvatarRingsState extends State<_AvatarRings>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final scale = 1.0 + (_ctrl.value * 0.06);
          return SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: const BoxDecoration(
                        color: Color(0x22DA9C5F), shape: BoxShape.circle),
                  ),
                ),
                Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                      color: Colors.black45, shape: BoxShape.circle),
                  child:
                      const Icon(Icons.person, size: 64, color: Colors.white54),
                ),
              ],
            ),
          );
        });
  }
}

class _ProfileChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ProfileChip({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0x14FFFFFF),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFDA9C5F), size: 12),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(color: Color(0xFFCBD5E0), fontSize: 11)),
        ],
      ),
    );
  }
}
