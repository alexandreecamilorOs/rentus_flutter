import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive_config.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/models/property_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final propertiesAsync = ref.watch(myPropertiesProvider);

    if (user == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0A09),
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFFDA9C5F))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          // 1. Unified Cinematic Background
          const _UnifiedBackground(),

          // 2. Main Content (Scrollable)
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: ResponsiveConfig.adaptivePadding(
                      horizontal: 16, vertical: 40),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      // 3. Hero Section
                      _HeroSection(
                          user: user, pulseController: _pulseController),
                      const SizedBox(height: 32),

                      // 4. Stats & Bio
                      _StatsAndBio(
                          user: user,
                          propertyCount: propertiesAsync.value?.length ?? 0),
                      const SizedBox(height: 24),

                      // 5. Info Grid
                      _InfoGrid(user: user),
                      const SizedBox(height: 40),

                      // 6. Properties Header
                      _SectionHeader(
                        title: 'Mis Propiedades',
                        count: propertiesAsync.value?.length ?? 0,
                        onAdd: () => context.push('/properties/create'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // 7. Properties List
              propertiesAsync.when(
                data: (properties) => properties.isEmpty
                    ? SliverToBoxAdapter(
                        child: _EmptyPropertiesState(
                          onAdd: () => context.push('/properties/create'),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                _PropertyListItem(property: properties[index]),
                            childCount: properties.length,
                          ),
                        ),
                      ),
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFDA9C5F))),
                ),
                error: (e, _) => SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error cargando propiedades: $e',
                        style: const TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ),

              // 8. Social Links & Footer
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: _SocialButtons(),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () => ref.read(authProvider.notifier).logout(),
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Top Navigation
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
              icon: const Icon(Icons.arrow_back, color: Color(0xFFF0E5DB)),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black45,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Background Components (Unified with Home) ---

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
              colors: [Color(0xFF0D0A09), Color(0xFF241711), Color(0xFF3B251D)],
            ),
          ),
        ),
        const _CinematicParticles(),
      ],
    );
  }
}

class _CinematicParticles extends StatefulWidget {
  const _CinematicParticles();

  @override
  State<_CinematicParticles> createState() => _CinematicParticlesState();
}

class _CinematicParticlesState extends State<_CinematicParticles>
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

    for (int i = 0; i < 60; i++) {
      double x = (i * 53) % w;
      double yBase = ((i * 97) % h);
      double y = (yBase + ya) % h;

      paintA.color =
          i % 3 == 0 ? const Color(0x44DA9C5F) : const Color(0x22F6D2A5);
      canvas.drawCircle(Offset(x, y), 1.5 + (i % 3), paintA);
    }

    for (int i = 0; i < 40; i++) {
      double x = (i * 71 + 32) % w;
      double yBase = ((i * 113) % h);
      double y = (yBase + yb) % h;

      paintB.color = Colors.white.withOpacity(0.12);
      canvas.drawCircle(Offset(x, y), 1.0 + (i % 2), paintB);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}

// --- Content Components ---

class _HeroSection extends StatelessWidget {
  final dynamic user;
  final AnimationController pulseController;

  const _HeroSection({required this.user, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PulsingAvatar(photo: user.photo, controller: pulseController),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                user.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF0E5DB),
                  letterSpacing: -0.5,
                  shadows: [Shadow(color: Color(0x66DA9C5F), blurRadius: 10)],
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 24),
          ],
        ),
        Text(
          '@${user.email.split("@")[0]}',
          style: const TextStyle(
              color: Color(0xFFA0AEC0),
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0x1ADA9C5F),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x33DA9C5F)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Color(0xFFDA9C5F), size: 14),
              const SizedBox(width: 8),
              Text(
                user.address ?? 'Sin ubicación',
                style: const TextStyle(
                    color: Color(0xFFDA9C5F),
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PulsingAvatar extends StatelessWidget {
  final String? photo;
  final AnimationController controller;

  const _PulsingAvatar({this.photo, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 1; i <= 3; i++)
              Container(
                width: 130 + (i * 20 * controller.value),
                height: 130 + (i * 20 * controller.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDA9C5F).withOpacity(0.3 / i),
                    width: 1.5,
                  ),
                ),
              ),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x80DA9C5F), width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black87, blurRadius: 20)
                ],
                image: (photo != null && photo!.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(photo!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (photo == null || photo!.isEmpty)
                  ? const Icon(Icons.person, size: 70, color: Color(0xFFDA9C5F))
                  : null,
            ),
          ],
        );
      },
    );
  }
}

class _StatsAndBio extends StatelessWidget {
  final dynamic user;
  final int propertyCount;
  const _StatsAndBio({required this.user, required this.propertyCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bio Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0x08FFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x26DA9C5F)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.notes, color: Color(0xFFF0E5DB), size: 18),
                  SizedBox(width: 8),
                  Text('Acerca de mí',
                      style: TextStyle(
                          color: Color(0xFFF0E5DB),
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Usuario verificado de Rentus. Bienvenido a mi perfil exclusivo.',
                style: TextStyle(
                    color: Color(0xFFCBD5E0), fontSize: 14, height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Stats Grid
        Row(
          children: [
            _buildStatCard(
                'Anuncios', '$propertyCount', Icons.home_work_outlined),
            const SizedBox(width: 12),
            _buildStatCard('Favoritos', '0', Icons.favorite_border),
            const SizedBox(width: 12),
            _buildStatCard('Puntos', '500', Icons.stars_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0x08FFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x26DA9C5F)),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFDA9C5F), size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Color(0xFFDA9C5F),
                    fontSize: 22,
                    fontWeight: FontWeight.w900)),
            Text(label.toUpperCase(),
                style: const TextStyle(
                    color: Color(0xFFA0AEC0),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final dynamic user;
  const _InfoGrid({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildInfoCard('EMAIL', user.email, Icons.email_outlined),
            const SizedBox(width: 12),
            _buildInfoCard(
                'CELULAR', user.phone ?? 'N/A', Icons.phone_android_outlined),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildInfoCard(
                'IDENTIDAD', user.idDocumento ?? 'N/A', Icons.badge_outlined),
            const SizedBox(width: 12),
            _buildInfoCard('ROL', user.role?.toUpperCase() ?? 'SOCIO',
                Icons.admin_panel_settings_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x05FFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x26DA9C5F)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0x26DA9C5F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFDA9C5F), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: Color(0xFFA0AEC0),
                          fontSize: 9,
                          fontWeight: FontWeight.bold)),
                  Text(
                    value,
                    style: const TextStyle(
                        color: Color(0xFFF0E5DB),
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onAdd;

  const _SectionHeader(
      {required this.title, required this.count, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.maps_home_work_outlined,
                color: Color(0xFFF0E5DB), size: 22),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xFFF0E5DB),
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFDA9C5F), Color(0xFFB8791F)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('$count',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        IconButton(
          onPressed: onAdd,
          icon:
              const Icon(Icons.add_circle, color: Color(0xFFDA9C5F), size: 28),
        ),
      ],
    );
  }
}

class _PropertyListItem extends StatelessWidget {
  final Property property;
  const _PropertyListItem({required this.property});

  @override
  Widget build(BuildContext context) {
    final imageUrl = property.propertyImages.isNotEmpty
        ? property.propertyImages.first.url
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0x08FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1ADA9C5F)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: imageUrl != null
                      ? Image.network(imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const _PlaceholderImage())
                      : const _PlaceholderImage(),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xCCDA9C5F),
                      borderRadius: BorderRadius.circular(12),
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          property.title,
                          style: const TextStyle(
                              color: Color(0xFFF0E5DB),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${property.price?.toStringAsFixed(0) ?? "Consultar"}',
                        style: const TextStyle(
                            color: Color(0xFF2ECC71),
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Color(0xFFA0AEC0), size: 14),
                      const SizedBox(width: 4),
                      Text(property.city,
                          style: const TextStyle(
                              color: Color(0xFFA0AEC0), fontSize: 13)),
                    ],
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

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0x1AFFFFFF),
      child:
          const Icon(Icons.image_outlined, color: Color(0x4DDA9C5F), size: 40),
    );
  }
}

class _EmptyPropertiesState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyPropertiesState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0x05FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1ADA9C5F)),
      ),
      child: Column(
        children: [
          const Icon(Icons.home_outlined, size: 60, color: Color(0x4DDA9C5F)),
          const SizedBox(height: 20),
          const Text('Aún no tienes propiedades',
              style: TextStyle(
                  color: Color(0xFFF0E5DB),
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text('Tus anuncios aparecerán aquí cuando los publiques.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFA0AEC0), fontSize: 14)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Publicar Ahora'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDA9C5F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButtons extends StatelessWidget {
  const _SocialButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialBtn(const Color(0xFF1877F2), Icons.facebook),
        const SizedBox(width: 16),
        _buildSocialBtn(const Color(0xFFE1306C), Icons.camera_alt_outlined),
        const SizedBox(width: 16),
        _buildSocialBtn(const Color(0xFF1DA1F2), Icons.alternate_email),
        const SizedBox(width: 16),
        _buildSocialBtn(const Color(0xFF0077B5), Icons.link),
      ],
    );
  }

  Widget _buildSocialBtn(Color color, IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0x12FFFFFF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}
