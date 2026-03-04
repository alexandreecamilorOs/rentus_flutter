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
          const _CinematicBackground(),

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
                      const SizedBox(height: 32),

                      // 5.1 Management Grid (NEW)
                      const _ManagementGrid(),
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

class _CinematicBackground extends StatelessWidget {
  const _CinematicBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D0A09), Color(0xFF140F0D), Color(0xFF1A1412)],
            ),
          ),
        ),
        // Glow Orbs
        Positioned(
          top: -150,
          right: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.1),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -100,
          left: -150,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.05),
            size: 450,
          ),
        ),
        const _CinematicParticles(),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
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
      duration: const Duration(seconds: 15),
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
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      double x = (i * 137 + phase * 50) % w;
      double y = (i * 223 - phase * 80) % h;
      if (y < 0) y += h;

      paint.color = Colors.white.withOpacity(0.05 + (i % 5) * 0.01);
      canvas.drawCircle(Offset(x, y), 0.5 + (i % 2), paint);
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
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFF0E5DB),
                  letterSpacing: -0.8,
                  height: 1.1,
                  shadows: [
                    Shadow(color: Color(0x99DA9C5F), blurRadius: 20),
                    Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 4),
                        blurRadius: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '@${user.email.split("@")[0]}',
              style: const TextStyle(
                color: Color(0xFFDA9C5F),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const _VerifiedBadge(),
          ],
        ),
        const SizedBox(height: 20),
        _LocationBadge(location: user.address ?? user.city ?? 'Colombia'),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, color: Color(0xFF3B82F6), size: 12),
          SizedBox(width: 4),
          Text(
            'VERIFICADO',
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationBadge extends StatelessWidget {
  final String location;
  const _LocationBadge({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1ADA9C5F)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFDA9C5F).withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.location_on, color: Color(0xFFDA9C5F), size: 16),
          const SizedBox(width: 8),
          Text(
            location,
            style: const TextStyle(
              color: Color(0xFFF0E5DB),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
            // Outer Glow Rings
            for (int i = 1; i <= 3; i++)
              Container(
                width: 140 + (i * 15 * controller.value),
                height: 140 + (i * 15 * controller.value),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFDA9C5F).withOpacity(0.2 / i),
                    width: 1.0,
                  ),
                ),
              ),

            // Background Circle with Gradient Border
            Container(
              width: 140,
              height: 140,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFDA9C5F), Color(0xFFB8791F)],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF1A0E0A),
                  image: (photo != null && photo!.isNotEmpty)
                      ? DecorationImage(
                          image: NetworkImage(photo!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDA9C5F).withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: (photo == null || photo!.isEmpty)
                    ? const Icon(Icons.person,
                        size: 70, color: Color(0xFFDA9C5F))
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatsAndBio extends StatefulWidget {
  final dynamic user;
  final int propertyCount;
  const _StatsAndBio({required this.user, required this.propertyCount});

  @override
  State<_StatsAndBio> createState() => _StatsAndBioState();
}

class _StatsAndBioState extends State<_StatsAndBio> {
  late TextEditingController _bioController;
  bool _isEditing = false;
  late String _bio;

  @override
  void initState() {
    super.initState();
    _bio = widget.user.bio ?? 'Sin biografía redactada.';
    _bioController = TextEditingController(text: _bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_isEditing) {
        // Save logic would go here, updating local state for now
        _bio = _bioController.text;
      }
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bio Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0x0AFFFFFF),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0x1ADA9C5F)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome,
                          color: Color(0xFFDA9C5F), size: 18),
                      SizedBox(width: 10),
                      Text(
                        'MI BIOGRAFÍA',
                        style: TextStyle(
                          color: Color(0xFFF0E5DB),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _toggleEdit,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isEditing
                            ? const Color(0xFFDA9C5F)
                            : const Color(0x1AFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isEditing ? Icons.check : Icons.edit_outlined,
                        color:
                            _isEditing ? Colors.black : const Color(0xFFDA9C5F),
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_isEditing)
                TextField(
                  controller: _bioController,
                  maxLines: 4,
                  maxLength: 240,
                  autofocus: true,
                  style: const TextStyle(
                      color: Color(0xFFF0E5DB), fontSize: 14, height: 1.5),
                  decoration: InputDecoration(
                    hintText: 'Cuéntanos un poco sobre ti...',
                    hintStyle: TextStyle(
                        color: const Color(0xFFF0E5DB).withOpacity(0.3)),
                    border: InputBorder.none,
                    counterStyle:
                        const TextStyle(color: Color(0xFFDA9C5F), fontSize: 10),
                  ),
                )
              else
                Text(
                  _bio,
                  style: const TextStyle(
                    color: Color(0xFFCBD5E0),
                    fontSize: 14,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Stats Grid
        Row(
          children: [
            _buildStatCard(
                'ANUNCIOS', '${widget.propertyCount}', Icons.home_work_rounded),
            const SizedBox(width: 12),
            _buildStatCard('RESEÑAS', '4.9', Icons.star_rounded),
            const SizedBox(width: 12),
            _buildStatCard('RENTAL', 'Gold', Icons.workspace_premium_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x1ADA9C5F)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFDA9C5F).withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0x1ADA9C5F),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFDA9C5F), size: 18),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4),
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
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
            _buildInfoCard('EMAIL', user.email, Icons.email_rounded),
            const SizedBox(width: 12),
            _buildInfoCard('CELULAR', user.phone ?? 'No registrado',
                Icons.phone_android_rounded),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildInfoCard('IDENTIDAD', user.idDocumento ?? 'Pendiente',
                Icons.badge_rounded),
            const SizedBox(width: 12),
            _buildInfoCard('ROL', user.role?.toUpperCase() ?? 'MIEMBRO',
                Icons.admin_panel_settings_rounded),
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
          color: const Color(0x06FFFFFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x1ADA9C5F)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0x1ADA9C5F),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFFDA9C5F), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        color: const Color(0xFFF0E5DB).withOpacity(0.35),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                        color: Color(0xFFF0E5DB),
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x1ADA9C5F)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const _PlaceholderImage(),
                        )
                      : const _PlaceholderImage(),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: _StatusBadge(status: property.status ?? 'published'),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xCCDA9C5F),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDA9C5F).withOpacity(0.5),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Text(
                      '\$${property.price?.toStringAsFixed(0) ?? "No disp."}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          color: Color(0xFFDA9C5F), size: 14),
                      const SizedBox(width: 6),
                      Text(
                        '${property.address}, ${property.city}',
                        style: TextStyle(
                          color: const Color(0xFFF0E5DB).withOpacity(0.5),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildFeature(Icons.king_bed_outlined,
                          '${property.numBedrooms} Hab'),
                      const SizedBox(width: 16),
                      _buildFeature(Icons.bathtub_outlined,
                          '${property.numBathrooms} Baños'),
                      const Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {}, // Quick View logic
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x1AFFFFFF),
                              borderRadius: BorderRadius.circular(12),
                              border:
                                  Border.all(color: const Color(0x1ADA9C5F)),
                            ),
                            child: const Icon(Icons.edit_outlined,
                                color: Color(0xFFDA9C5F), size: 18),
                          ),
                        ),
                      ),
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

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFDA9C5F).withOpacity(0.7), size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xFFF0E5DB).withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isPublished = status.toLowerCase() == 'published';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPublished ? const Color(0xCC2ECC71) : const Color(0xCCF1C40F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _ManagementGrid extends StatelessWidget {
  const _ManagementGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PANEL DE GESTIÓN",
          style: TextStyle(
            color: Color(0xFFDA9C5F),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.4,
          children: [
            _ManagementCard(
              title: "Mis Contratos",
              subtitle: "Gestión de firmas",
              icon: Icons.description_rounded,
              onTap: () => context.push('/contracts'),
            ),
            _ManagementCard(
              title: "Pagos y Rentas",
              subtitle: "Historial de transacciones",
              icon: Icons.payments_rounded,
              onTap: () => context.push('/payments'),
            ),
            _ManagementCard(
              title: "Mantenimiento",
              subtitle: "Solicitudes técnicas",
              icon: Icons.build_circle_rounded,
              onTap: () => context.push('/maintenance'),
            ),
            _ManagementCard(
              title: "Mis Reportes",
              subtitle: "Quejas y sugerencias",
              icon: Icons.report_problem_rounded,
              onTap: () => context.push('/reports'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ManagementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ManagementCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x0AFFFFFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x1ADA9C5F)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x1ADA9C5F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFDA9C5F), size: 24),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
