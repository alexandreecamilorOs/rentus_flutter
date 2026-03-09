import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/responsive_config.dart';
import 'upward_particles.dart';

class ModernDrawer extends StatelessWidget {
  const ModernDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final drawerWidth = ResponsiveConfig.byBreakpoint<double>(
      smallMobile: 280,
      mobile: 320,
      tablet: 350,
    );

    return Container(
      width: drawerWidth,
      padding: EdgeInsets.fromLTRB(
        0,
        MediaQuery.of(context).padding.top + 10,
        15,
        20,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(right: Radius.circular(40)),
        child: Drawer(
          width: drawerWidth,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Stack(
            children: [
              // 1. Premium Glass Layer
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1E1410).withOpacity(0.9),
                        const Color(0xFF0D0A09).withOpacity(0.95),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              // 2. Cinematic Particles
              const UpwardParticles(particleCount: 15),

              // 3. Drawer Content
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const _DrawerHeader(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Divider(
                              height: 1,
                              color: const Color(0xFFDA9C5F).withOpacity(0.2),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Column(
                            children: [
                              _DrawerItem(
                                icon: Icons.person_outline_rounded,
                                label: 'Mi Perfil',
                                delay: 0,
                                onTap: () => context.go('/profile'),
                              ),
                              _DrawerItem(
                                icon: Icons.notifications_none_rounded,
                                label: 'Notificaciones',
                                delay: 50,
                                badgeCount: 3,
                                onTap: () => context.go('/notifications'),
                              ),
                              _DrawerItem(
                                icon: Icons.description_outlined,
                                label: 'Contratos',
                                delay: 100,
                                onTap: () => context.go('/contracts'),
                              ),
                              _DrawerItem(
                                icon: Icons.payments_outlined,
                                label: 'Pagos',
                                delay: 150,
                                onTap: () => context.go('/payments'),
                              ),
                              const _SectionDivider(label: 'SOLICITUDES'),
                              _DrawerItem(
                                icon: Icons.build_outlined,
                                label: 'Mantenimiento',
                                delay: 200,
                                onTap: () => context.go('/maintenance'),
                              ),
                              _DrawerItem(
                                icon: Icons.assignment_outlined,
                                label: 'Solicitudes Dueño',
                                delay: 250,
                                onTap: () => context.go('/owner_requests'),
                              ),
                              _DrawerItem(
                                icon: Icons.calendar_today_outlined,
                                label: 'Mis Solicitudes',
                                delay: 300,
                                onTap: () => context.go('/owner_requests'),
                              ),
                              const _SectionDivider(label: 'AJUSTES'),
                              _DrawerItem(
                                icon: Icons.flag_outlined,
                                label: 'Mis Reportes',
                                delay: 350,
                                onTap: () => context.go('/reports'),
                              ),
                              _DrawerItem(
                                icon: Icons.settings_outlined,
                                label: 'Ajustes',
                                delay: 400,
                                onTap: () => context.go('/settings'),
                              ),
                              _DrawerItem(
                                icon: Icons.groups_rounded,
                                label: 'Sobre Nosotros',
                                delay: 425,
                                onTap: () => context.go('/about'),
                              ),
                              const SizedBox(height: 20),
                              _DrawerItem(
                                icon: Icons.logout_rounded,
                                label: 'Cerrar Sesión',
                                delay: 450,
                                isLogout: true,
                                onTap: () => context.go('/login'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                  // Premium Footer
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Text(
                          'RENTUS',
                          style: TextStyle(
                            color: const Color(0xFFDA9C5F).withOpacity(0.5),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'v1.0.0 Premium Edition',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.2),
                            fontSize: 10,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatefulWidget {
  const _DrawerHeader();

  @override
  State<_DrawerHeader> createState() => _DrawerHeaderState();
}

class _DrawerHeaderState extends State<_DrawerHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Profile Section with Breathing Glow
              AnimatedBuilder(
                animation: _glowController,
                builder: (context, child) {
                  return Container(
                    width: 85,
                    height: 85,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDA9C5F)
                              .withOpacity(0.2 + (_glowController.value * 0.3)),
                          blurRadius: 15 + (_glowController.value * 15),
                          spreadRadius: 2 + (_glowController.value * 4),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFDA9C5F),
                          const Color(0xFFDA9C5F).withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: child,
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1A1A1A),
                    image: DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/150?u=rentus'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // Premium Badge or Close Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white.withOpacity(0.2),
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          // User Info with better typography
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alexandre Camilo',
                style: TextStyle(
                  fontSize: ResponsiveConfig.fontSize(24),
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDA9C5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFFDA9C5F).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      size: 12,
                      color: Color(0xFFDA9C5F),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Premium Member',
                      style: TextStyle(
                        fontSize: ResponsiveConfig.fontSize(11),
                        color: const Color(0xFFDA9C5F),
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int delay;
  final VoidCallback onTap;
  final int badgeCount;
  final bool isLogout;

  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.delay,
    required this.onTap,
    this.badgeCount = 0,
    this.isLogout = false,
  });

  @override
  State<_DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<_DrawerItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + widget.delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onHover: (hover) => setState(() => _isHovered = hover),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: _isHovered
                    ? LinearGradient(
                        colors: [
                          const Color(0xFFDA9C5F).withOpacity(0.15),
                          const Color(0xFFDA9C5F).withOpacity(0.02),
                        ],
                      )
                    : null,
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: const Color(0xFFDA9C5F).withOpacity(0.05),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Icon Wrapper with subtle glow
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: widget.isLogout
                          ? const Color(0xFFE74C3C).withOpacity(0.1)
                          : _isHovered
                              ? const Color(0xFFDA9C5F).withOpacity(0.2)
                              : const Color(0xFFDA9C5F).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: _isHovered && !widget.isLogout
                          ? [
                              BoxShadow(
                                color: const Color(0xFFDA9C5F).withOpacity(0.2),
                                blurRadius: 10,
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 22,
                      color: widget.isLogout
                          ? const Color(0xFFE74C3C)
                          : const Color(0xFFDA9C5F),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            _isHovered ? FontWeight.w800 : FontWeight.w600,
                        color: widget.isLogout
                            ? const Color(0xFFE74C3C)
                            : Colors.white.withOpacity(_isHovered ? 1.0 : 0.8),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  if (widget.badgeCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE74C3C), Color(0xFFC0392B)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE74C3C).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        '${widget.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  if (!widget.isLogout)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _isHovered ? 1.0 : 0.3,
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: Color(0xFFDA9C5F),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  const _SectionDivider({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 25, 25, 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: const Color(0xFFDA9C5F).withOpacity(0.4),
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              height: 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFDA9C5F).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
