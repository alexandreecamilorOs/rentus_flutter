import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/property_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../components/home_navbar.dart';
import '../../components/modern_drawer.dart';
import '../../components/modern_header.dart';
import '../../components/modern_view_wrapper.dart';
import '../../components/upward_particles.dart';
import '../../../core/services/location_service.dart';
import 'map_property_card.dart';

class MapExplorerScreen extends ConsumerStatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final int? selectedId;

  const MapExplorerScreen({
    super.key,
    this.initialLat,
    this.initialLng,
    this.selectedId,
  });

  @override
  ConsumerState<MapExplorerScreen> createState() => _MapExplorerScreenState();
}

class _MapExplorerScreenState extends ConsumerState<MapExplorerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  final MapController _mapController = MapController();
  Property? _selectedProperty;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  double _currentRotation = 0.0;

  // Center on Colombia by default if no properties
  static const _defaultCenter = LatLng(4.6097, -74.0817); // Bogota

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(propertyListProvider);

    // If a selectedId was passed and we haven't selected a property yet,
    // try to find it once properties are loaded.
    if (widget.selectedId != null && _selectedProperty == null) {
      propertiesAsync.whenData((state) {
        final prop = state.items.cast<Property?>().firstWhere(
              (p) => p?.id == widget.selectedId,
              orElse: () => null,
            );
        if (prop != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _selectedProperty == null) {
              setState(() => _selectedProperty = prop);
            }
          });
        }
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      onDrawerChanged: (isOpened) {
        setState(() => _isDrawerOpen = isOpened);
      },
      drawer: const ModernDrawer(),
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          // 1. Unified Background (mostly hidden by map, but good for edges)
          const Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0D0A09),
                        Color(0xFF1E1410),
                      ],
                    ),
                  ),
                ),
              ),
              UpwardParticles(particleCount: 15),
            ],
          ),

          // 2. The Map
          Positioned.fill(
            child: propertiesAsync.when(
              data: (state) {
                final properties = state.items;
                return _buildMap(properties);
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: Color(0xFFDA9C5F))),
              error: (err, stack) => Center(
                child: Text(
                  'Error al cargar propiedades',
                  style: TextStyle(color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
          ),

          // 3.1 Dark gradient overlays (Top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 180,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF0D0A09),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 3.2 Dark gradient overlays (Bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 200,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF0D0A09),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 4. Fixed Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ModernHeader(
              isDrawerOpen: _isDrawerOpen,
              onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),

          // 4.1 Search Bar (Premium Floating)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: _buildSearchBar(),
          ),

          // 4.2 Map Controls (Locate Me, Compass)
          Positioned(
            right: 20,
            top: 170,
            child: _buildMapControls(),
          ),

          // 5. Selected Property Card
          if (_selectedProperty != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 120, // Above NavBar
              child: MapPropertyCard(
                property: _selectedProperty!,
                onClose: () => setState(() => _selectedProperty = null),
                onTap: () => context.go('/properties/${_selectedProperty!.id}'),
              ),
            ),

          // 6. Bottom Navbar
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Mapa",
              onNavigateHome: () => context.go('/home'),
              onNavigateProperties: () => context.go('/properties'),
              onNavigateMap: () => context.go('/map'),
              onNavigateProfile: () => context.go('/profile'),
              onNavigateNotifications: () => context.go('/notifications'),
              onNavigateContracts: () => context.go('/contracts'),
              onNavigatePayments: () => context.go('/payments'),
              onNavigateMaintenance: () => context.go('/maintenance'),
              onNavigateMyRequests: () => context.go('/owner_requests'),
              onNavigateMyReports: () => context.go('/reports'),
              onNavigateSettings: () => context.go('/settings'),
            ),
          ),
        ],
      ),
    ).modernWrapped();
  }

  Widget _buildMap(List<Property> properties) {
    // Determine center based on first valid property or default
    final validProperties = properties
        .where((p) => p.lat != null && p.lng != null && p.lat != 0)
        .toList();

    // Generate markers
    final markers = properties.map((prop) {
      final bool hasRealCoords =
          prop.lat != null && prop.lng != null && prop.lat != 0;

      final latLng = hasRealCoords
          ? LatLng(prop.lat!, prop.lng!)
          : LatLng(_defaultCenter.latitude + (prop.id % 10) * 0.005,
              _defaultCenter.longitude + (prop.id % 7) * 0.005);

      final isSelected = _selectedProperty?.id == prop.id;

      return Marker(
        point: latLng,
        width: 130, // Increased for pill shape
        height: 50,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _selectedProperty = prop;
            });
            _mapController.move(latLng, 14.0);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
            child: _buildPillMarker(prop, isSelected),
          ),
        ),
      );
    }).toList();

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.initialLat != null && widget.initialLng != null
            ? LatLng(widget.initialLat!, widget.initialLng!)
            : (validProperties.isNotEmpty
                ? LatLng(validProperties.first.lat!, validProperties.first.lng!)
                : _defaultCenter),
        initialZoom: widget.selectedId != null ? 15.0 : 12.0,
        backgroundColor: const Color(0xFF0D0A09),
        onTap: (_, __) {
          if (_selectedProperty != null) {
            setState(() => _selectedProperty = null);
          }
        },
        onPositionChanged: (position, hasGesture) {
          if (hasGesture && position.rotation != _currentRotation) {
            setState(() => _currentRotation = position.rotation);
          }
        },
      ),
      children: [
        // Premium Light Map Tiles (for better visibility as requested)
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png",
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.example.rentus_flutter',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }

  Widget _buildSearchBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white, // Changed to white for better contrast
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFDA9C5F).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Color(0xFFDA9C5F)),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                  color: Color(0xFF1E1410), // Dark text on white bg
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: "Barranquilla, Bello, Medellín...",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
                  border: InputBorder.none,
                ),
                onSubmitted: _handleSearch,
              ),
            ),
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
            if (_isSearching)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFDA9C5F),
                ),
              )
            else
              IconButton(
                padding: EdgeInsets.zero,
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDA9C5F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () => _handleSearch(_searchController.text),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Column(
      children: [
        // Compass / Reset Rotation
        Transform.rotate(
          angle: -_currentRotation * (3.14159 / 180),
          child: _buildControlButton(
            icon: Icons.explore_rounded,
            onPressed: () {
              _mapController.rotate(0);
              setState(() => _currentRotation = 0);
            },
            label: "Norte",
          ),
        ),
        const SizedBox(height: 12),
        // Locate Me
        _buildControlButton(
          icon: Icons.my_location_rounded,
          onPressed: _locateMe,
          label: "Mi ubicación",
          isPrimary: true,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
    bool isPrimary = false,
  }) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isPrimary
                ? const Color(0xFFDA9C5F)
                : const Color(0xFF1E1410).withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPrimary
                  ? Colors.white.withOpacity(0.3)
                  : const Color(0xFFDA9C5F).withOpacity(0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: isPrimary ? Colors.white : const Color(0xFFDA9C5F),
            size: 24,
          ),
        ),
      ),
    );
  }

  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) return;

    setState(() => _isSearching = true);
    try {
      // Append Colombia for better geocoding results
      final fullQuery =
          query.toLowerCase().contains("colombia") ? query : "$query, Colombia";

      final coords = await LocationService.getCoordinatesFromAddress(fullQuery);
      if (coords != null) {
        _mapController.move(coords, 14.0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No se encontró la ubicación: $query"),
            backgroundColor: const Color(0xFF1E1410),
          ),
        );
      }
    } finally {
      setState(() => _isSearching = false);
    }
  }

  Widget _buildPillMarker(Property prop, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isSelected ? const Color(0xFFDA9C5F) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Property Image (Circular)
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              prop.mainImage,
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 35,
                height: 35,
                color: Colors.grey[300],
                child: const Icon(Icons.home, size: 20, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Price Info
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$${_formatPrice(prop.price)}",
                style: const TextStyle(
                  color: Color(0xFF1E1410),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 6),
          // Status Dot
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF27AE60), // Green for available
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  String _formatPrice(double? price) {
    if (price == null) return "0";
    if (price >= 1000000) {
      return "${(price / 1000000).toStringAsFixed(1)}M";
    } else if (price >= 1000) {
      return "${(price / 1000).toStringAsFixed(0)}K";
    }
    return price.toInt().toString();
  }

  Future<void> _locateMe() async {
    final position = await LocationService.getCurrentPosition();
    if (position != null) {
      final latLng = LatLng(position.latitude, position.longitude);
      _mapController.move(latLng, 15.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudo obtener la ubicación actual"),
          backgroundColor: Color(0xFF1E1410),
        ),
      );
    }
  }
}
