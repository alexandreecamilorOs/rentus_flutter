import 'dart:ui';
import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';

class HomeNavbar extends StatefulWidget {
  final String selectedTab;
  final VoidCallback? onNavigateHome;
  final VoidCallback? onNavigateProperties;
  final VoidCallback? onNavigateMap;
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
    this.onNavigateMap,
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
  int get selectedIndex {
    switch (widget.selectedTab) {
      case 'Propiedades':
        return 1;
      case 'Mapa':
        return 2;
      case 'Inicio':
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navbarHeight = ResponsiveConfig.byBreakpoint<double>(
      smallMobile: 70,
      mobile: 76,
      tablet: 86,
    );

    return SafeArea(
      bottom: true,
      child: Container(
        height: ResponsiveConfig.getProportionateScreenHeight(navbarHeight),
        margin: EdgeInsets.only(
          left: ResponsiveConfig.adaptiveSpacing(mobile: 24),
          right: ResponsiveConfig.adaptiveSpacing(mobile: 24),
          bottom: ResponsiveConfig.getProportionateScreenHeight(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              ResponsiveConfig.getProportionateScreenWidth(40)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD59A).withOpacity(0.15),
              blurRadius: 30,
              spreadRadius: -5,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              ResponsiveConfig.getProportionateScreenWidth(40)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x9915100E),
                border: Border.all(color: const Color(0x33FFD59A), width: 1.5),
                borderRadius: BorderRadius.circular(
                    ResponsiveConfig.getProportionateScreenWidth(40)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final totalWidth = constraints.maxWidth;
                  final itemWidth = totalWidth / 3;

                  return Stack(
                    children: [
                      // Sliding Indicator Capsule
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutBack,
                        left: selectedIndex * itemWidth,
                        top: 0,
                        bottom: 0,
                        width: itemWidth,
                        child: Center(
                          child: Container(
                            width: itemWidth * 0.70,
                            height:
                                ResponsiveConfig.getProportionateScreenHeight(
                                    48),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE5A95D), Color(0xFFC78133)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFE5A95D).withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Icons & Text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _AnimatedNavItem(
                            label: 'Inicio',
                            icon: Icons.home_rounded,
                            isSelected: selectedIndex == 0,
                            onTap: widget.onNavigateHome,
                            width: itemWidth,
                          ),
                          _AnimatedNavItem(
                            label: 'Explorar',
                            icon: Icons.apartment_rounded,
                            isSelected: selectedIndex == 1,
                            onTap: widget.onNavigateProperties,
                            width: itemWidth,
                          ),
                          _AnimatedNavItem(
                            label: 'Mapa',
                            icon: Icons.map_outlined,
                            isSelected: selectedIndex == 2,
                            onTap: widget.onNavigateMap,
                            width: itemWidth,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;
  final double width;

  const _AnimatedNavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              transform: Matrix4.identity()
                ..scale(isSelected ? 1.05 : 1.0)
                ..translate(0.0, isSelected ? -4.0 : 0.0),
              child: AnimatedTheme(
                data: ThemeData(
                    iconTheme: IconThemeData(
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFFFFD59A).withOpacity(0.35),
                )),
                child: Icon(
                  icon,
                  size: ResponsiveConfig.getProportionateScreenWidth(
                      isSelected ? 26 : 24),
                ),
              ),
            ),
            SizedBox(height: ResponsiveConfig.getProportionateScreenHeight(2)),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1.0 : 0.0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuint,
                offset: isSelected ? Offset.zero : const Offset(0, 0.4),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveConfig.fontSize(10),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
