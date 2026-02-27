import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import 'package:go_router/go_router.dart';

class PropertyEditScreen extends StatefulWidget {
  const PropertyEditScreen({super.key});

  @override
  State<PropertyEditScreen> createState() => _PropertyEditScreenState();
}

class _PropertyEditScreenState extends State<PropertyEditScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _cityCtrl;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: "Penthouse Sky Lounge");
    _descCtrl = TextEditingController(
        text: "Vista panorámica y diseño minimalista 2026");
    _priceCtrl = TextEditingController(text: "6200000");
    _cityCtrl = TextEditingController(text: "Medellín");
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

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
                const Text("PROPERTY EDIT",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
                const Row(
                  children: [
                    Icon(Icons.edit, color: Color(0xFFDA9C5F)),
                    SizedBox(width: 6),
                    Text("Editar propiedad",
                        style: TextStyle(
                            color: Color(0xFFFFF4E8),
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1.1)),
                  ],
                ),
                const SizedBox(height: 12),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: _saved
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                              color: const Color(0x222ECC71),
                              borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.all(12),
                          child: const Text("Cambios guardados correctamente",
                              style: TextStyle(
                                  color: Color(0xFF98F5C0),
                                  fontWeight: FontWeight.bold)),
                        )
                      : const SizedBox.shrink(),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xE62E1D17),
                      borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Información básica",
                          style: TextStyle(
                              color: Color(0xFFFFE7C7),
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      _EditField("Título", _titleCtrl),
                      const SizedBox(height: 10),
                      _EditField("Descripción", _descCtrl),
                      const SizedBox(height: 10),
                      _EditField("Precio mensual", _priceCtrl),
                      const SizedBox(height: 10),
                      _EditField("Ciudad", _cityCtrl),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppActionButton(
                        text: "Cancelar",
                        onClick: () => context.go('/properties/detail'),
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
                        onClick: () => setState(() => _saved = true),
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

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _EditField(this.label, this.controller);

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
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
