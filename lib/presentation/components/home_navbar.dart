import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';

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
    this.selectedTab = "Inicio",
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
    ResponsiveConfig.init(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ResponsiveConfig.getProportionateScreenWidth(20)),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        final menuItems = [
          {"label": "Mi Perfil", "icon": Icons.person, "action": widget.onNavigateProfile},
          {"label": "Notificaciones", "icon": Icons.notifications, "action": widget.onNavigateNotifications},
          {"label": "Contratos", "icon": Icons.apartment, "action": widget.onNavigateContracts},
          {"label": "Pagos", "icon": Icons.payments, "action": widget.onNavigatePayments},
          {"label": "Mantenimiento", "icon": Icons.build, "action": widget.onNavigateMaintenance},
          {"label": "Solicitudes (Dueño)", "icon": Icons.description, "action": widget.onNavigateRequests},
          {"label": "Mis Solicitudes", "icon": Icons.sms, "action": widget.onNavigateMyRequests},
          {"label": "Mis Reportes", "icon": Icons.flag, "action": widget.onNavigateMyReports},
          {"label": "Ajustes", "icon": Icons.settings, "action": widget.onNavigateSettings},
        ];

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveConfig.getProportionateScreenWidth(18),
            vertical: ResponsiveConfig.getProportionateScreenHeight(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Opciones",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveConfig.fontSize(20),
                  color: const Color(0xFF2C3E50),
                ),
              ),
              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(16)),
              ...menuItems.map((item) {
                return InkWell(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(12)),
                  splashColor: const Color(0xFFDA9C5F).withOpacity(0.2),
                  onTap: () {
                    Navigator.pop(context);
                    if (item['action'] != null) {
                      (item['action'] as VoidCallback)();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveConfig.getProportionateScreenHeight(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: ResponsiveConfig.getProportionateScreenWidth(36),
                          height: ResponsiveConfig.getProportionateScreenWidth(36),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E3D0),
                            borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(10)),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: const Color(0xFF3B251D),
                            size: ResponsiveConfig.getProportionateScreenWidth(20),
                          ),
                        ),
                        SizedBox(width: ResponsiveConfig.getProportionateScreenWidth(12)),
                        Flexible(
                          child: Text(
                            item['label'] as String,
                            style: TextStyle(
                              color: const Color(0xFF2C3E50),
                              fontSize: ResponsiveConfig.fontSize(15),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(24)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig.init(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      height: isLandscape
          ? ResponsiveConfig.getProportionateScreenHeight(96)
          : ResponsiveConfig.getProportionateScreenHeight(86),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ResponsiveConfig.getProportionateScreenWidth(24)),
          topRight: Radius.circular(ResponsiveConfig.getProportionateScreenWidth(24)),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC3B251D), Color(0xD92E1D17)],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveConfig.getProportionateScreenWidth(14),
        vertical: ResponsiveConfig.getProportionateScreenHeight(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MorphingNavItem(label: "Inicio", icon: Icons.home, selected: widget.selectedTab == "Inicio", onClick: widget.onNavigateHome),
                _MorphingNavItem(label: "Propiedades", icon: Icons.apartment, selected: widget.selectedTab == "Propiedades", onClick: widget.onNavigateProperties),
                _MorphingNavItem(label: "Nosotros", icon: Icons.groups, selected: widget.selectedTab == "Nosotros", onClick: widget.onNavigateAbout),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _showMenu(context),
              customBorder: const CircleBorder(),
              splashColor: Colors.white.withOpacity(0.2),
              child: Container(
                width: ResponsiveConfig.getProportionateScreenWidth(42),
                height: ResponsiveConfig.getProportionateScreenWidth(42),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [Color(0xFFDA9C5F), Color(0xFF8A5D34)]),
                ),
                child: Icon(Icons.menu, color: Colors.white, size: ResponsiveConfig.getProportionateScreenWidth(24)),
              ),
            ),
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

  const _MorphingNavItem({required this.label, required this.icon, required this.selected, this.onClick});

  @override
  State<_MorphingNavItem> createState() => _MorphingNavItemState();
}

class _MorphingNavItemState extends State<_MorphingNavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig.init(context);
    final scale = _isPressed ? 0.92 : (widget.selected ? 1.08 : 1.0);
    final iconTint = widget.selected ? const Color(0xFFDA9C5F) : Colors.white.withOpacity(0.78);
    final bubbleWidth = widget.selected
        ? ResponsiveConfig.getProportionateScreenWidth(52)
        : ResponsiveConfig.getProportionateScreenWidth(38);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onClick?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(24)),
        splashColor: const Color(0xFFFFD59A).withOpacity(0.24),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.fastOutSlowIn,
                width: bubbleWidth,
                height: ResponsiveConfig.getProportionateScreenHeight(34),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(17)),
                  gradient: widget.selected
                      ? const LinearGradient(colors: [Color(0x99DA9C5F), Color(0x663B251D)])
                      : const LinearGradient(colors: [Colors.transparent, Colors.transparent]),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.icon,
                      key: ValueKey<bool>(widget.selected),
                      color: widget.selected ? const Color(0xFFFFE7C7) : iconTint,
                      size: widget.selected
                          ? ResponsiveConfig.getProportionateScreenWidth(24)
                          : ResponsiveConfig.getProportionateScreenWidth(22),
                    ),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(2)),
              if (widget.selected)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: widget.selected ? 1.0 : 0.0,
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: const Color(0xFFFFE7C7),
                      fontSize: ResponsiveConfig.fontSize(10),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(2)),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: widget.selected
                    ? ResponsiveConfig.getProportionateScreenWidth(20)
                    : ResponsiveConfig.getProportionateScreenWidth(6),
                height: ResponsiveConfig.getProportionateScreenHeight(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(1.5)),
                  gradient: widget.selected
                      ? const LinearGradient(colors: [Color(0xFFFFD59A), Color(0xFFDA9C5F)])
                      : const LinearGradient(colors: [Colors.transparent, Colors.transparent]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
