import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import 'package:go_router/go_router.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _imageIndex = 0;
  // Usamos iconos de placeholder por ahora, como en Compose (R.drawable.casa)
  final List<IconData> _gallery = [Icons.image, Icons.home, Icons.apartment];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0E0A),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A0E0A),
                  Color(0xFF2E1D17),
                  Color(0xFF3B2416)
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 14, bottom: 100),
              children: [
                const Text("PROPERTY DETAIL",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                const Text("Penthouse Sky Lounge",
                    style: TextStyle(
                        color: Color(0xFFFFF4E8),
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                        height: 1.1)),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFFDA9C5F), size: 14),
                    SizedBox(width: 4),
                    Text("El Poblado, Medellín",
                        style:
                            TextStyle(color: Color(0xFFD4C5B9), fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xE62E1D17),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                _gallery[_imageIndex],
                                key: ValueKey<int>(_imageIndex),
                                size: 64,
                                color: Colors.white24,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_imageIndex > 0)
                                        setState(() => _imageIndex--);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: const Color(0x77000000),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Icon(Icons.chevron_left,
                                          color: Colors.white),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_imageIndex < _gallery.length - 1)
                                        setState(() => _imageIndex++);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: const Color(0x77000000),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: const Icon(Icons.chevron_right,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                  color: const Color(0xAA2ECC71),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.white, size: 12),
                                  SizedBox(width: 4),
                                  Text("Disponible",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xE62E1D17),
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("\$6.200.000 / mes",
                          style: TextStyle(
                              color: Color(0xFFDA9C5F),
                              fontSize: 24,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      const Text(
                          "Vista panorámica, acabados de lujo y amenities premium.",
                          style: TextStyle(
                              color: Color(0xFFE8D7C8), fontSize: 13)),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          _FeatureChip(icon: Icons.bed, text: "4 hab"),
                          SizedBox(width: 8),
                          _FeatureChip(icon: Icons.bathtub, text: "4 baños"),
                          SizedBox(width: 8),
                          _FeatureChip(icon: Icons.star, text: "220m²"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      AppActionButton(
                        text: "Editar propiedad",
                        onClick: () => context.go('/properties/edit'),
                        gradient: const [
                          Color(0xFF6366F1),
                          Color(0xFF4F46E5),
                          Color(0xFF6366F1)
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Propiedades",
              onNavigateHome: () => context.go('/home'),
              onNavigateProperties: () => context.go('/properties'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: const Color(0x33DA9C5F),
          borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFDA9C5F), size: 12),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(color: Color(0xFFF0E5DB), fontSize: 11)),
        ],
      ),
    );
  }
}
