import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/property_model.dart';

class MapMiniView extends StatelessWidget {
  final List<Property> properties;
  final LatLng? initialCenter;
  final double initialZoom;
  final VoidCallback? onTap;
  final String? label;
  final double height;

  const MapMiniView({
    super.key,
    required this.properties,
    this.initialCenter,
    this.initialZoom = 13.0,
    this.onTap,
    this.label,
    this.height = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    // Logic to determine center if not provided
    LatLng center =
        initialCenter ?? const LatLng(4.6097, -74.0817); // Default Bogota

    final validProperties = properties
        .where(
            (p) => p.lat != null && p.lng != null && p.lat != 0 && p.lng != 0)
        .toList();

    if (initialCenter == null && validProperties.isNotEmpty) {
      center = LatLng(validProperties.first.lat!, validProperties.first.lng!);
    }

    final markers = validProperties.map((p) {
      return Marker(
        point: LatLng(p.lat!, p.lng!),
        width: 12,
        height: 12,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFDA9C5F),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFDA9C5F).withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
        ),
      );
    }).toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x26DA9C5F)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // 1. The Map
              IgnorePointer(
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: initialZoom,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png",
                      subdomains: const ['a', 'b', 'c', 'd'],
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
              ),

              // 2. Premium Overlays
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Label / CTA
              Positioned(
                bottom: 16,
                left: 16,
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFFDA9C5F), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      label ?? "Explorar en mapa",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Live Badge (Optional / Premium touch)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2ECC71),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "En vivo",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
