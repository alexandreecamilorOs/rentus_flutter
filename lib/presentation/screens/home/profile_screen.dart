import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/responsive_config.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/models/property_model.dart';
import '../../../data/models/user_model.dart';
import '../../components/upward_particles.dart';

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
      body: RefreshIndicator(
        color: const Color(0xFFDA9C5F),
        backgroundColor: const Color(0xFF1E1410),
        onRefresh: () async {
          await ref.read(authProvider.notifier).refreshUserProfile();
          // Also refresh properties
          ref.invalidate(myPropertiesProvider);
        },
        child: Stack(
          children: [
            const _ProfileBackground(),

            // 2. Main Content (Scrollable)
            CustomScrollView(
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: ResponsiveConfig.adaptivePadding(
                        horizontal: 16, vertical: 90),
                    child: Column(
                      children: [
                        // Staggered Animations (Phase 7.4 Web Parity)
                        _FadeIn(
                          delay: Duration.zero,
                          child: _HeroSection(
                              user: user, pulseController: _pulseController),
                        ),
                        const SizedBox(height: 32),

                        _SlideUp(
                          delay: const Duration(milliseconds: 100),
                          child: _StatsAndBio(
                              user: user,
                              propertyCount:
                                  propertiesAsync.value?.length ?? 0),
                        ),
                        const SizedBox(
                            height: 32), // Increased from 24 for better spacing

                        _SlideUp(
                          delay: const Duration(milliseconds: 200),
                          child: _InfoGrid(user: user),
                        ),
                        const SizedBox(height: 32),

                        _SlideUp(
                          delay: const Duration(milliseconds: 300),
                          child: const _ManagementGrid(),
                        ),
                        const SizedBox(height: 40),

                        _FadeIn(
                          delay: const Duration(milliseconds: 400),
                          child: _SectionHeader(
                            title: 'Mis Propiedades',
                            count: propertiesAsync.value?.length ?? 0,
                            onAdd: () => context.push('/properties/create'),
                          ),
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
                              (context, index) => _PropertyListItem(
                                  property: properties[index]),
                              childCount: properties.length,
                            ),
                          ),
                        ),
                  loading: () => const SliverToBoxAdapter(
                    child: Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFDA9C5F))),
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
                        onPressed: () =>
                            ref.read(authProvider.notifier).logout(),
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

            // Top Navigation (Consolidated)
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.all(12),
                  shape: const CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Background Components (Unified with Home) ---

class _ProfileBackground extends StatelessWidget {
  const _ProfileBackground();

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
        const UpwardParticles(),
        // Glow Orbs
        Positioned(
          top: -150,
          right: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.08),
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

// --- Content Components ---

class _HeroSection extends StatelessWidget {
  final User user;
  final AnimationController pulseController;

  const _HeroSection({required this.user, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PulsingAvatar(photo: user.photo, controller: pulseController),
        const SizedBox(height: 28),
        // Name + Verified Badge Row (Literal Web Parity)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user.name.isEmpty ? 'Usuario Rentus' : user.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28, // Increased from 26
                fontWeight: FontWeight.w900,
                letterSpacing: -1.0, // Tighter tracking for premium feel
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 24),
          ],
        ),
        const SizedBox(height: 16),
        // Location Badge Center
        _LocationBadge(location: user.address ?? user.city ?? 'Popayán, Cauca'),
      ],
    );
  }
}

class _LocationBadge extends StatelessWidget {
  final String location;
  const _LocationBadge({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDA9C5F).withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(),
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

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
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
            color: const Color(0xFF2ECC71),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2ECC71)
                    .withOpacity(0.5 * _controller.value),
                blurRadius: 8 * _controller.value,
                spreadRadius: 2 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PulsingAvatar extends ConsumerWidget {
  final String? photo;
  final AnimationController controller;

  const _PulsingAvatar({this.photo, required this.controller});

  Future<void> _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      debugPrint('Photo picked: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer Glow Rings (Fixed visibility)
            for (int i = 1; i <= 3; i++)
              Transform.scale(
                scale: 1.0 + (0.2 * controller.value), // Increased visibility
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDA9C5F).withOpacity(
                        (0.6 - (i * 0.15)) * (1.0 - (0.2 * controller.value)),
                      ),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

            // Avatar Wrapper
            GestureDetector(
              onTap: () => _pickImage(ref),
              child: Transform.scale(
                scale: 1.0 + (0.08 * controller.value), // Reduced pulse 1.08
                child: Container(
                  width: 150,
                  height: 150,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDA9C5F).withOpacity(0.5),
                      width: 3.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDA9C5F).withOpacity(
                            0.3 + (0.3 * controller.value)), // Glow 0.3 -> 0.6
                        blurRadius:
                            15 + (15 * controller.value), // Glow 15px -> 30px
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: (photo != null && photo!.isNotEmpty)
                              ? Image.network(
                                  photo!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Color(0xFFDA9C5F)),
                                )
                              : Container(
                                  color: const Color(0xFF1A0E0A),
                                  child: const Icon(Icons.person,
                                      size: 80, color: Color(0xFFDA9C5F)),
                                ),
                        ),
                        // Camera Overlay
                        Positioned.fill(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const Icon(Icons.camera_alt,
                                  color: Colors.white, size: 32),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatsAndBio extends StatefulWidget {
  final User user;
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
    _bio = widget.user.bio ??
        'Apasionado por los bienes raíces y el diseño moderno.';
    _bioController = TextEditingController(text: _bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      setState(() => _bio = _bioController.text);
      // Here would go the API call to update bio
    }
    setState(() => _isEditing = !_isEditing);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Anuncios',
                  count: '${widget.propertyCount}',
                  icon: Icons.grid_view_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  label: 'Seguidores',
                  count: '1.2k',
                  icon: Icons.people_outline,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatCard(
                  label: 'Ranking',
                  count: '4.9',
                  icon: Icons.star_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Bio Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0x0AFFFFFF),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0x1AFFFFFF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
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
                          'BIOGRAFÍA',
                          style: TextStyle(
                            color: Color(0xFFDA9C5F),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
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
                          _isEditing
                              ? Icons.check_rounded
                              : Icons.edit_outlined,
                          color: _isEditing
                              ? Colors.black
                              : const Color(0xFFDA9C5F),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (_isEditing)
                  TextField(
                    controller: _bioController,
                    maxLines: 4,
                    maxLength: 240,
                    autofocus: true,
                    style: const TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 15,
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cuéntanos un poco sobre ti...',
                      hintStyle: TextStyle(
                        color: const Color(0xFFF0E5DB).withOpacity(0.3),
                      ),
                      border: InputBorder.none,
                      counterStyle: const TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 10,
                      ),
                    ),
                  )
                else
                  Text(
                    _bio,
                    style: TextStyle(
                      color: const Color(0xFFF0E5DB).withOpacity(0.8),
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String count;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
          14), // Matching '.stat-card-compact { padding: 14px }'
      decoration: BoxDecoration(
        color: const Color(0x08FFFFFF), // ~0.03 opacity
        borderRadius:
            BorderRadius.circular(14), // Matching 'border-radius: 14px'
        border: Border.all(
          color: const Color(0xFFDA9C5F)
              .withOpacity(0.15), // Matching 'rgba(218, 156, 95, 0.15)'
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFDA9C5F), size: 20),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final User user;
  const _InfoGrid({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildInfoCard(
                'EMAIL',
                user.email.isEmpty ? 'No registrado' : user.email,
                Icons.email_outlined),
            const SizedBox(width: 14), // Matching 'gap: 14px' from CSS
            _buildInfoCard(
                'CELULAR',
                (user.phone == null || user.phone!.isEmpty)
                    ? 'No registrado'
                    : user.phone!,
                Icons.phone_android_outlined),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _buildInfoCard('IDENTIDAD', user.idDocumento ?? 'Pendiente',
                Icons.badge_outlined),
            const SizedBox(width: 14),
            _buildInfoCard('ROL', user.role?.toUpperCase() ?? 'MIEMBRO',
                Icons.shield_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.all(20), // Matching '.info-card { padding: 20px }'
        decoration: BoxDecoration(
          color: const Color(
              0x05FFFFFF), // Matching '.info-card { background: rgba(255, 255, 255, 0.02) }'
          borderRadius: BorderRadius.circular(
              18), // Matching '.info-card { border-radius: 18px }'
          border: Border.all(
            color: const Color(0xFFDA9C5F).withOpacity(
                0.15), // Matching 'border: 1px solid rgba(218, 156, 95, 0.15)'
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(0.15), // Reduced shadow as per CSS
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(
                  10), // Matching '.info-card-icon { padding: 10px }'
              decoration: BoxDecoration(
                color: const Color(0xFFDA9C5F)
                    .withOpacity(0.15), // Matching 'rgba(218, 156, 95, 0.15)'
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: const Color(0xFFDA9C5F),
                  size: 22), // Matching 'font-size: 22px'
            ),
            const SizedBox(height: 15), // Reduced from 16
            Text(
              label,
              style: TextStyle(
                color: const Color(
                    0xFFA0AEC0), // Matching '.info-label { color: #a0aec0 }'
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.9, // Matching 'letter-spacing: 0.9px'
              ),
            ),
            const SizedBox(height: 3), // Matching 'gap: 3px'
            Text(
              value,
              style: const TextStyle(
                color: Color(
                    0xFFF0E5DB), // Matching '.info-value { color: #f0e5db }'
                fontSize: 14, // Matching 'font-size: 14px'
                fontWeight: FontWeight.w600, // Matching 'font-weight: 600'
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback onAdd;

  const _SectionHeader({
    required this.title,
    required this.count,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFDA9C5F),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$count Propiedades publicadas',
                style: TextStyle(
                  color: const Color(0xFFF0E5DB).withOpacity(0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onAdd,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x1ADA9C5F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_rounded,
                  color: Color(0xFFDA9C5F), size: 20),
            ),
          ),
        ],
      ),
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
                  child: imageUrl != null && imageUrl.isNotEmpty
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
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            "PANEL DE GESTIÓN",
            style: TextStyle(
              color: Color(0xFFDA9C5F),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _ManagementCard(
              title: "Mis Contratos",
              subtitle: "Gestión de firmas",
              icon: Icons.description_outlined,
              onTap: () => context.push('/contracts'),
            ),
            _ManagementCard(
              title: "Pagos y Rentas",
              subtitle: "Historial",
              icon: Icons.payments_outlined,
              onTap: () => context.push('/payments'),
            ),
            _ManagementCard(
              title: "Mantenimiento",
              subtitle: "Soporte técnico",
              icon: Icons.build_outlined,
              onTap: () => context.push('/maintenance'),
            ),
            _ManagementCard(
              title: "Mis Reportes",
              subtitle: "Incidencias",
              icon: Icons.report_problem_outlined,
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              const Color(0x05FFFFFF), // Matching 'rgba(255, 255, 255, 0.02)'
          borderRadius: BorderRadius.circular(18), // Reduced from 28
          border: Border.all(
            color: const Color(0xFFDA9C5F).withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 28,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0x1ADA9C5F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFDA9C5F), size: 22),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4),
                fontSize: 10,
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

// --- Animation Helpers (Phase 7.4 Web Parity) ---

class _FadeIn extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _FadeIn({required this.child, this.delay = Duration.zero});

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Matching 'translateY(25px)' from CSS
    _offset =
        Tween<Offset>(begin: const Offset(0, 25), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
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
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _offset.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _SlideUp extends StatefulWidget {
  final Widget child;
  final Duration delay;
  const _SlideUp({required this.child, this.delay = Duration.zero});

  @override
  State<_SlideUp> createState() => _SlideUpState();
}

class _SlideUpState extends State<_SlideUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Matching 'translateY(15px)' from CSS
    _offset =
        Tween<Offset>(begin: const Offset(0, 15), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
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
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: _offset.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
