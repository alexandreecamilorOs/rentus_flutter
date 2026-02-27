import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import 'package:go_router/go_router.dart';

class PropertyCreateScreen extends StatefulWidget {
  const PropertyCreateScreen({super.key});

  @override
  State<PropertyCreateScreen> createState() => _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends State<PropertyCreateScreen> {
  String _title = "";
  String _description = "";
  String _address = "";
  String _city = "";
  String _price = "";
  String _bedrooms = "";
  String _bathrooms = "";
  bool _success = false;

  final List<String> _selectedServices = [];
  final List<String> _services = [
    "WiFi",
    "Parqueadero",
    "Piscina",
    "Gimnasio",
    "A/C",
    "Mascotas"
  ];

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
                const Text("PROPERTY CREATE 2026",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                const Text("Publicar Propiedad",
                    style: TextStyle(
                        color: Color(0xFFFFF4E8),
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                        height: 1.1)),
                const SizedBox(height: 4),
                const Text(
                    "Crea tu publicación con estilo premium y animaciones modernas.",
                    style: TextStyle(color: Color(0xFFD4C5B9), fontSize: 12)),
                const SizedBox(height: 12),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: _success
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: const Color(0x2232CD72),
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.all(12),
                          child: const Row(
                            children: [
                              Icon(Icons.check, color: Color(0xFF2ECC71)),
                              SizedBox(width: 8),
                              Text("Propiedad creada correctamente",
                                  style: TextStyle(
                                      color: Color(0xFFE5FFE9),
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                _SectionCard(
                  title: "Información básica",
                  icon: Icons.sell,
                  child: Column(
                    children: [
                      _Field("Título", _title,
                          (val) => setState(() => _title = val)),
                      const SizedBox(height: 10),
                      _Field("Descripción", _description,
                          (val) => setState(() => _description = val)),
                      const SizedBox(height: 10),
                      _Field("Precio mensual", _price,
                          (val) => setState(() => _price = val)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: "Ubicación",
                  icon: Icons.location_on,
                  child: Column(
                    children: [
                      _Field("Dirección", _address,
                          (val) => setState(() => _address = val)),
                      const SizedBox(height: 10),
                      _Field("Ciudad", _city,
                          (val) => setState(() => _city = val)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: "Características",
                  icon: Icons.add_location_alt,
                  child: Column(
                    children: [
                      _Field("Habitaciones", _bedrooms,
                          (val) => setState(() => _bedrooms = val),
                          leading: const Icon(Icons.bed)),
                      const SizedBox(height: 10),
                      _Field("Baños", _bathrooms,
                          (val) => setState(() => _bathrooms = val),
                          leading: const Icon(Icons.bathtub)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: "Servicios",
                  icon: Icons.check,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _services.map((service) {
                      final selected = _selectedServices.contains(service);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selected) {
                              _selectedServices.remove(service);
                            } else {
                              _selectedServices.add(service);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0x44DA9C5F)
                                : const Color(0x22FFFFFF),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(selected ? Icons.check : Icons.close,
                                  color: const Color(0xFFDA9C5F), size: 14),
                              const SizedBox(width: 5),
                              Text(service,
                                  style: const TextStyle(
                                      color: Color(0xFFF0E5DB), fontSize: 12)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                const _SectionCard(
                  title: "Imágenes",
                  icon: Icons.image,
                  child: Text(
                      "Carga de imágenes simulada (UI lista para integrar lógica real)",
                      style: TextStyle(color: Color(0xFFBFAFA2), fontSize: 12)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppActionButton(
                        text: "Cancelar",
                        onClick: () => context.go('/properties'),
                        gradient: const [
                          Color(0xFF64748B),
                          Color(0xFF475569),
                          Color(0xFF64748B)
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppActionButton(
                        text: "Guardar",
                        onClick: () => setState(() => _success = true),
                        gradient: const [
                          Color(0xFFDA9C5F),
                          Color(0xFFB8791F),
                          Color(0xFFDA9C5F)
                        ],
                      ),
                    ),
                  ],
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

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard(
      {required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color(0xE62E1D17),
          borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFDA9C5F)),
              const SizedBox(width: 6),
              Text(title,
                  style: const TextStyle(
                      color: Color(0xFFFFE7C7), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  final Widget? leading;
  final ValueChanged<String> onChange;

  const _Field(this.label, this.value, this.onChange, {this.leading});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFFD4C5B9),
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        TextField(
          onChanged: onChange,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: leading,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
