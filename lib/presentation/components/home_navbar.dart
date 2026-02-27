import 'package:flutter/material.dart';

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
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFAFAFA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        final menuItems = [
          {
            "label": "Mi Perfil",
            "icon": Icons.person,
            "action": widget.onNavigateProfile
          },
          {
            "label": "Notificaciones",
            "icon": Icons.notifications,
            "action": widget.onNavigateNotifications
          },
          {
            "label": "Contratos",
            "icon": Icons.apartment,
            "action": widget.onNavigateContracts
          },
          {
            "label": "Pagos",
            "icon": Icons.payments,
            "action": widget.onNavigatePayments
          },
          {
            "label": "Mantenimiento",
            "icon": Icons.build,
            "action": widget.onNavigateMaintenance
          },
          {
            "label": "Solicitudes (Dueño)",
            "icon": Icons.description,
            "action": widget.onNavigateRequests
          },
          {
            "label": "Mis Solicitudes",
            "icon": Icons.sms,
            "action": widget.onNavigateMyRequests
          },
          {
            "label": "Mis Reportes",
            "icon": Icons.flag,
            "action": widget.onNavigateMyReports
          },
          {
            "label": "Ajustes",
            "icon": Icons.settings,
            "action": widget.onNavigateSettings
          },
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Opciones",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 16),
              ...menuItems.map((item) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    if (item['action'] != null) {
                      (item['action'] as VoidCallback)();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3E3D0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: const Color(0xFF3B251D),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            color: Color(0xFF2C3E50),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xCC3B251D),
            Color(0xD92E1D17),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MorphingNavItem(
                  label: "Inicio",
                  icon: Icons.home,
                  selected: widget.selectedTab == "Inicio",
                  onClick: widget.onNavigateHome,
                ),
                _MorphingNavItem(
                  label: "Propiedades",
                  icon: Icons.apartment,
                  selected: widget.selectedTab == "Propiedades",
                  onClick: widget.onNavigateProperties,
                ),
                _MorphingNavItem(
                  label: "Nosotros",
                  icon: Icons.groups,
                  selected: widget.selectedTab == "Nosotros",
                  onClick: widget.onNavigateAbout,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showMenu(context),
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0xFFDA9C5F), Color(0xFF8A5D34)],
                ),
              ),
              child: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 24,
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
    final scale = _isPressed ? 0.92 : (widget.selected ? 1.08 : 1.0);
    final iconTint = widget.selected
        ? const Color(0xFFDA9C5F)
        : Colors.white.withOpacity(0.78);
    final bubbleWidth = widget.selected ? 52.0 : 38.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (widget.onClick != null) widget.onClick!();
      },
      onTapCancel: () => setState(() => _isPressed = false),
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
              height: 34,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: widget.selected
                    ? const LinearGradient(
                        colors: [Color(0x99DA9C5F), Color(0x663B251D)],
                      )
                    : const LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                      ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    widget.icon,
                    key: ValueKey<bool>(widget.selected),
                    color: widget.selected ? const Color(0xFFFFE7C7) : iconTint,
                    size: widget.selected ? 24 : 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 2),
            if (widget.selected)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: widget.selected ? 1.0 : 0.0,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Color(0xFFFFE7C7),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: widget.selected ? 20.0 : 6.0,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1.5),
                gradient: widget.selected
                    ? const LinearGradient(
                        colors: [Color(0xFFFFD59A), Color(0xFFDA9C5F)],
                      )
                    : const LinearGradient(
                        colors: [Colors.transparent, Colors.transparent],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
