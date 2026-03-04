import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';
import 'luxury_wave_overlay.dart';

class HomeNavbar extends StatefulWidget {
  final String selectedTab;
  final VoidCallback? onNavigateHome;
  final VoidCallback? onNavigateProperties;
  final VoidCallback? onNavigateAbout;
  final VoidCallback? onNavigateProfile;
  final VoidCallback? onNavigateNotifications;
  final VoidCallback? onNavigateContracts;
  final VoidCallback? onNavigatePayments;
  final VoidCallback? onNavigateMaintenance;
  final VoidCallback? onNavigateMyRequests;
  final VoidCallback? onNavigateRequests;
  final VoidCallback? onNavigateMyReports;
  final VoidCallback? onNavigateSettings;

  const HomeNavbar({
    super.key,
    this.selectedTab = 'Inicio',
    this.onNavigateHome,
    this.onNavigateProperties,
    this.onNavigateAbout,
    this.onNavigateProfile,
    this.onNavigateNotifications,
    this.onNavigateContracts,
    this.onNavigatePayments,
    this.onNavigateMaintenance,
    this.onNavigateMyRequests,
    this.onNavigateRequests,
    this.onNavigateMyReports,
    this.onNavigateSettings,
  });

  @override
  State<HomeNavbar> createState() => _HomeNavbarState();
}

class _HomeNavbarState extends State<HomeNavbar> {
  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final menuItems = [
          {
            'label': 'Mi Perfil',
            'icon': Icons.person,
            'action': widget.onNavigateProfile
          },
          {
            'label': 'Notificaciones',
            'icon': Icons.notifications,
            'action': widget.onNavigateNotifications
          },
          {
            'label': 'Contratos',
            'icon': Icons.apartment,
            'action': widget.onNavigateContracts
          },
          {
            'label': 'Pagos',
            'icon': Icons.payments,
            'action': widget.onNavigatePayments
          },
          {
            'label': 'Mantenimiento',
            'icon': Icons.build,
            'action': widget.onNavigateMaintenance
          },
          {
            'label': 'Solicitudes (Dueño)',
            'icon': Icons.description,
            'action': widget.onNavigateRequests
          },
          {
            'label': 'Mis Solicitudes',
            'icon': Icons.sms,
            'action': widget.onNavigateMyRequests
          },
          {
            'label': 'Mis Reportes',
            'icon': Icons.flag,
            'action': widget.onNavigateMyReports
          },
          {
            'label': 'Ajustes',
            'icon': Icons.settings,
            'action': widget.onNavigateSettings
          },
        ];

        return Container(
          margin: EdgeInsets.all(ResponsiveConfig.adaptiveSpacing(mobile: 12)),
          padding:
              ResponsiveConfig.adaptivePadding(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE8E2).withOpacity(0.82),
            borderRadius: BorderRadius.circular(
                ResponsiveConfig.getProportionateScreenWidth(24)),
            border: Border.all(color: Colors.white.withOpacity(0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Opciones',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.4,
                  fontSize: ResponsiveConfig.fontSize(20),
                  color: const Color(0xFF2C3E50),
                ),
              ),
              SizedBox(
                  height: ResponsiveConfig.getProportionateScreenHeight(16)),
              ...menuItems.map((item) => InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      (item['action'] as VoidCallback?)?.call();
                    },
                    borderRadius: BorderRadius.circular(
                        ResponsiveConfig.getProportionateScreenWidth(14)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical:
                            ResponsiveConfig.getProportionateScreenHeight(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: ResponsiveConfig.getProportionateScreenWidth(
                                36),
                            height:
                                ResponsiveConfig.getProportionateScreenWidth(
                                    36),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E3D0),
                              borderRadius: BorderRadius.circular(
                                  ResponsiveConfig.getProportionateScreenWidth(
                                      10)),
                            ),
                            child: Icon(
                              item['icon'] as IconData,
                              color: const Color(0xFF3B251D),
                              size:
                                  ResponsiveConfig.getProportionateScreenWidth(
                                      20),
                            ),
                          ),
                          SizedBox(
                              width:
                                  ResponsiveConfig.getProportionateScreenWidth(
                                      12)),
                          Expanded(
                            child: Text(
                              item['label'] as String,
                              style: TextStyle(
                                color: const Color(0xFF2C3E50),
                                fontSize: ResponsiveConfig.fontSize(15),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final navbarHeight = ResponsiveConfig.byBreakpoint<double>(
      smallMobile: 80,
      mobile: 86,
      tablet: 96,
    );

    return Container(
      height: ResponsiveConfig.getProportionateScreenHeight(navbarHeight),
      margin: EdgeInsets.symmetric(
          horizontal: ResponsiveConfig.adaptiveSpacing(mobile: 8)),
      padding: ResponsiveConfig.adaptivePadding(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            ResponsiveConfig.getProportionateScreenWidth(24)),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC3B251D), Color(0xD92E1D17)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: ResponsiveConfig.getProportionateScreenWidth(22),
            offset: Offset(0, ResponsiveConfig.getProportionateScreenHeight(8)),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MorphingNavItem(
                  label: 'Inicio',
                  icon: Icons.home,
                  selected: widget.selectedTab == 'Inicio',
                  onClick: widget.onNavigateHome,
                ),
                _MorphingNavItem(
                  label: 'Propiedades',
                  icon: Icons.apartment,
                  selected: widget.selectedTab == 'Propiedades',
                  onClick: widget.onNavigateProperties,
                ),
                _MorphingNavItem(
                  label: 'Nosotros',
                  icon: Icons.groups,
                  selected: widget.selectedTab == 'Nosotros',
                  onClick: widget.onNavigateAbout,
                ),
              ],
            ),
          ),
          _WaveIconButton(
            icon: Icons.menu,
            onTap: () => _showMenu(context),
            gradient: const [Color(0xFFDA9C5F), Color(0xFF8A5D34)],
          ),
        ],
      ),
    );
  }
}

class _MorphingNavItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onClick;

  const _MorphingNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    this.onClick,
  });

  @override
  State<_MorphingNavItem> createState() => _MorphingNavItemState();
}

class _MorphingNavItemState extends State<_MorphingNavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bubbleWidth = widget.selected ? 52.0 : 38.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onClick?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.93 : (widget.selected ? 1.08 : 1),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _WaveIconButton(
              icon: widget.icon,
              selected: widget.selected,
              width: bubbleWidth,
              height: 34,
              onTap: widget.onClick,
              gradient: widget.selected
                  ? const [Color(0x99DA9C5F), Color(0x663B251D)]
                  : const [Colors.transparent, Colors.transparent],
            ),
            SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(2)),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: widget.selected ? 1 : 0,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: const Color(0xFFFFE7C7),
                  fontSize: ResponsiveConfig.fontSize(10),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool selected;
  final double width;
  final double height;
  final List<Color> gradient;

  const _WaveIconButton({
    required this.icon,
    required this.gradient,
    this.onTap,
    this.selected = false,
    this.width = 42,
    this.height = 42,
  });

  @override
  State<_WaveIconButton> createState() => _WaveIconButtonState();
}

class _WaveIconButtonState extends State<_WaveIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1550),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: ResponsiveConfig.getProportionateScreenWidth(widget.width),
        height: ResponsiveConfig.getProportionateScreenHeight(widget.height),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              ResponsiveConfig.getProportionateScreenWidth(18)),
          gradient: LinearGradient(
            colors: widget.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: LuxuryWaveOverlay(
                animation: _controller,
                color: const Color(0xFFFFD59A),
              ),
            ),
            Icon(
              widget.icon,
              color: widget.selected
                  ? const Color(0xFFFFE7C7)
                  : Colors.white.withOpacity(0.82),
              size: ResponsiveConfig.getProportionateScreenWidth(
                  widget.selected ? 24 : 22),
            ),
          ],
        ),
      ),
    );
  }
}
