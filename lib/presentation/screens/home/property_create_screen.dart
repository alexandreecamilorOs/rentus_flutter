import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/providers/repositories_providers.dart';
import '../../components/app_action_button.dart';

class PropertyCreateScreen extends ConsumerStatefulWidget {
  const PropertyCreateScreen({super.key});

  @override
  ConsumerState<PropertyCreateScreen> createState() =>
      _PropertyCreateScreenState();
}

class _PropertyCreateScreenState extends ConsumerState<PropertyCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _areaController = TextEditingController();
  final _dateController = TextEditingController();

  String _status = 'available';
  final List<String> _includedServices = [];
  final List<String> _images = []; // Should store paths or URLs
  bool _isSaving = false;

  final List<Map<String, dynamic>> _availableServices = [
    {'value': 'water', 'icon': Icons.water_drop, 'label': 'Agua'},
    {'value': 'electricity', 'icon': Icons.bolt, 'label': 'Luz'},
    {'value': 'gas', 'icon': Icons.local_fire_department, 'label': 'Gas'},
    {'value': 'internet', 'icon': Icons.wifi, 'label': 'Internet'},
    {'value': 'cableTv', 'icon': Icons.tv, 'label': 'TV Cable'},
    {'value': 'security', 'icon': Icons.shield, 'label': 'Seguridad'},
    {'value': 'parking', 'icon': Icons.local_parking, 'label': 'Parqueo'},
    {'value': 'gym', 'icon': Icons.fitness_center, 'label': 'Gimnasio'},
    {'value': 'pool', 'icon': Icons.pool, 'label': 'Piscina'},
    {'value': 'bbqArea', 'icon': Icons.outdoor_grill, 'label': 'BBQ'},
    {
      'value': 'laundry',
      'icon': Icons.local_laundry_service,
      'label': 'Lavandería'
    },
    {'value': 'elevator', 'icon': Icons.elevator, 'label': 'Ascensor'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    _dateController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return 'COP \$0';
    final number = int.tryParse(value.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
    return NumberFormat.currency(
            locale: 'es_CO', symbol: 'COP \$', decimalDigits: 0)
        .format(number);
  }

  void _toggleService(String service) {
    setState(() {
      if (_includedServices.contains(service)) {
        _includedServices.remove(service);
      } else {
        _includedServices.add(service);
      }
    });
  }

  void _pickImage() {
    // For now, adding a luxury house placeholder to simulate picking
    setState(() {
      if (_images.length < 10) {
        _images.add(
            "https://images.unsplash.com/photo-1613490493576-7fde63acd811?q=80&w=2071&auto=format&fit=crop");
      }
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final repository = ref.read(propertyRepositoryProvider);

      // Simulating the FormData structure from Vue
      final data = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'status': _status,
        'monthly_price': double.tryParse(
                _priceController.text.replaceAll(RegExp(r'[^\d]'), '')) ??
            0.0,
        'area_m2': double.tryParse(_areaController.text),
        'num_bedrooms': int.tryParse(_bedroomsController.text),
        'num_bathrooms': int.tryParse(_bathroomsController.text),
        'included_services': jsonEncode(_includedServices),
        'publication_date': _dateController.text,
      };

      await repository.createProperty(data);

      if (!mounted) return;
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Propiedad publicada con éxito!'),
          backgroundColor: Color(0xFF27AE60),
        ),
      );
    } catch (e) {
      String message = 'Error: $e';
      if (e is DioException && e.response?.data != null) {
        final d = e.response!.data;
        if (d is Map && d['errors'] != null) {
          message = (d['errors'] as Map)
              .values
              .expand((element) => (element is List ? element : [element]))
              .join(', ');
        } else if (d is Map && d['message'] != null) {
          message = d['message'];
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color(0xFFE74C3C),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          // 1. Cinematic Background with Orbs
          const _CinematicBackground(),

          SafeArea(
            child: Column(
              children: [
                // Top Padding for header spacing
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Header ──
                          _HeaderSection(),
                          const SizedBox(height: 40),

                          // ── Información Básica ──
                          _SectionCard(
                            title: "Información Básica",
                            subtitle: "Título, descripción y estado actual",
                            icon: Icons.info_outline,
                            children: [
                              _LuxuryTextField(
                                controller: _titleController,
                                label: "Título de la Propiedad",
                                hint: "Ej: Loft Moderno en el Poblado",
                                required: true,
                              ),
                              const SizedBox(height: 20),
                              _LuxuryTextField(
                                controller: _descriptionController,
                                label: "Descripción",
                                hint:
                                    "Cuéntanos los detalles más destacados...",
                                maxLines: 5,
                                required: true,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _LuxuryDropdown(
                                      label: "Estado",
                                      value: _status,
                                      items: const [
                                        {
                                          'value': 'available',
                                          'label': 'Disponible'
                                        },
                                        {'value': 'rented', 'label': 'Rentado'},
                                        {
                                          'value': 'maintenance',
                                          'label': 'Mantenimiento'
                                        },
                                      ],
                                      onChanged: (val) =>
                                          setState(() => _status = val!),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _LuxuryTextField(
                                      controller: _dateController,
                                      label: "Fecha Publicación",
                                      hint: "AAAA-MM-DD",
                                      onTap: () async {
                                        final date = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                        );
                                        if (date != null) {
                                          _dateController.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(date);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ── Ubicación ──
                          _SectionCard(
                            title: "Ubicación",
                            subtitle: "Dirección exacta y ciudad",
                            icon: Icons.map_outlined,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: _LuxuryTextField(
                                      controller: _addressController,
                                      label: "Dirección",
                                      hint: "Ej: Carrera 43A #1-50",
                                      required: true,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _LuxuryTextField(
                                      controller: _cityController,
                                      label: "Ciudad",
                                      hint: "Medellín",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _InfoBanner(
                                  text:
                                      "La ubicación exacta ayuda a los inquilinos a decidirse más rápido."),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ── Características ──
                          _SectionCard(
                            title: "Características",
                            subtitle: "Precio, área y distribución",
                            icon: Icons.tune_outlined,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _LuxuryTextField(
                                          controller: _priceController,
                                          label: "Precio Mensual",
                                          hint: "0",
                                          prefixText: "\$ ",
                                          keyboardType: TextInputType.number,
                                          required: true,
                                          onChanged: (v) => setState(() {}),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _formatCurrency(
                                              _priceController.text),
                                          style: const TextStyle(
                                            color: Color(0xFF27AE60),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _LuxuryTextField(
                                      controller: _areaController,
                                      label: "Área (m²)",
                                      hint: "0",
                                      suffixText: "m²",
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _LuxuryTextField(
                                      controller: _bedroomsController,
                                      label: "Habitaciones",
                                      hint: "0",
                                      icon: Icons.king_bed_outlined,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _LuxuryTextField(
                                      controller: _bathroomsController,
                                      label: "Baños",
                                      hint: "0",
                                      icon: Icons.bathtub_outlined,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ── Servicios ──
                          _SectionCard(
                            title: "Servicios",
                            subtitle: "Marca los servicios incluidos",
                            icon: Icons.checklist_rtl_outlined,
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 52,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: _availableServices.length,
                                itemBuilder: (context, index) {
                                  final service = _availableServices[index];
                                  final isSelected = _includedServices
                                      .contains(service['value']);
                                  return _ServiceItem(
                                    service: service,
                                    isSelected: isSelected,
                                    onTap: () =>
                                        _toggleService(service['value']),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // ── Imágenes ──
                          _SectionCard(
                            title: "Imágenes",
                            subtitle: "Sube hasta 10 fotos de la propiedad",
                            icon: Icons.photo_library_outlined,
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: (_images.length < 10)
                                    ? _images.length + 1
                                    : 10,
                                itemBuilder: (context, index) {
                                  if (index == _images.length &&
                                      _images.length < 10) {
                                    return _AddImageButton(onTap: _pickImage);
                                  }
                                  return _ImagePreviewItem(
                                    imageUrl: _images[index],
                                    onDelete: () => _removeImage(index),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              if (_images.isEmpty)
                                _InfoBanner(
                                  text:
                                      "Las propiedades con más de 5 fotos reciben un 40% más de interés.",
                                ),
                            ],
                          ),

                          const SizedBox(height: 48),

                          // ── Actions ──
                          Row(
                            children: [
                              Expanded(
                                child: AppActionButton(
                                  text: "Cancelar",
                                  isSecondary: true,
                                  onClick: () => context.pop(),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: AppActionButton(
                                  text: _isSaving
                                      ? "Procesando..."
                                      : "Publicar Propiedad",
                                  onClick: _submit,
                                  icon: _isSaving
                                      ? null
                                      : Icons.rocket_launch_outlined,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Color(0xFFDA9C5F), size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CinematicBackground extends StatelessWidget {
  const _CinematicBackground();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D0A09), Color(0xFF1E1410), Color(0xFF2E1D17)],
            ),
          ),
        ),
        // Image overlay with low opacity
        Positioned.fill(
          child: Opacity(
            opacity: 0.1,
            child: Image.network(
              "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=2070&auto=format&fit=crop",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
        ),
        // Orbs
        _BackgroundOrb(
            top: -200,
            right: -200,
            color: const Color(0xFFDA9C5F).withOpacity(0.18)),
        _BackgroundOrb(
            bottom: -150,
            left: -150,
            color: const Color(0xFFB8791F).withOpacity(0.15)),
      ],
    );
  }
}

class _BackgroundOrb extends StatelessWidget {
  final double? top, right, bottom, left;
  final Color color;
  const _BackgroundOrb(
      {this.top, this.right, this.bottom, this.left, required this.color});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: 400,
        height: 400,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color,
              blurRadius: 150,
              spreadRadius: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFDA9C5F),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Color(0xFFDA9C5F), blurRadius: 8)],
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "CREACIÓN DE PROPIEDAD",
              style: TextStyle(
                  color: Color(0xFFDA9C5F),
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 1.5),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RichText(
          text: const TextSpan(
            style: TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -1),
            children: [
              TextSpan(text: "Publicar "),
              TextSpan(
                  text: "Propiedad",
                  style: TextStyle(
                      color: Color(0xFFDA9C5F),
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Completa los detalles para atraer a los mejores inquilinos.",
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 15),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;
  const _SectionCard(
      {required this.title,
      required this.subtitle,
      required this.icon,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF3E2418).withOpacity(0.95),
            const Color(0xFF2E1D17).withOpacity(0.95)
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFDA9C5F).withOpacity(0.15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFDA9C5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFFDA9C5F).withOpacity(0.2)),
                ),
                child: Icon(icon, color: const Color(0xFFDA9C5F), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Color(0xFFF0E5DB),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text(subtitle,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _LuxuryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool required;
  final int maxLines;
  final TextInputType keyboardType;
  final String? prefixText;
  final String? suffixText;
  final IconData? icon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;

  const _LuxuryTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.suffixText,
    this.icon,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
            children: [
              TextSpan(text: label.toUpperCase()),
              if (required)
                const TextSpan(
                    text: " *", style: TextStyle(color: Color(0xFFE74C3C))),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF130F0D), // Much darker background
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: const Color(0xFFDA9C5F).withOpacity(0.12)),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            onTap: onTap,
            readOnly: onTap != null,
            onChanged: onChanged,
            style: const TextStyle(color: Color(0xFFF0E5DB), fontSize: 15),
            validator:
                required ? (v) => v!.isEmpty ? "Campo requerido" : null : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.12)),
              prefixIcon: icon != null
                  ? Icon(icon,
                      color: const Color(0xFFDA9C5F).withOpacity(0.4), size: 18)
                  : null,
              prefixText: prefixText,
              prefixStyle: const TextStyle(
                  color: Color(0xFFDA9C5F), fontWeight: FontWeight.bold),
              suffixText: suffixText,
              suffixStyle: const TextStyle(
                  color: Color(0xFFDA9C5F), fontWeight: FontWeight.bold),
              border: InputBorder.none,
              filled: false, // Ensure no inherited white background
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _LuxuryDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<Map<String, String>> items;
  final Function(String?) onChanged;
  const _LuxuryDropdown(
      {required this.label,
      required this.value,
      required this.items,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF130F0D), // Much darker background
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: const Color(0xFFDA9C5F).withOpacity(0.12)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFF1E1410),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFFDA9C5F)),
              isExpanded: true,
              style: const TextStyle(color: Color(0xFFF0E5DB), fontSize: 15),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                    value: item['value'], child: Text(item['label']!));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final Map<String, dynamic> service;
  final bool isSelected;
  final VoidCallback onTap;
  const _ServiceItem(
      {required this.service, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFDA9C5F).withOpacity(0.1)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected
                  ? const Color(0xFFDA9C5F).withOpacity(0.5)
                  : const Color(0xFFDA9C5F).withOpacity(0.15)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: const Color(0xFFDA9C5F).withOpacity(0.1),
                      blurRadius: 8)
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 16,
              color: isSelected ? const Color(0xFFDA9C5F) : Colors.white10,
            ),
            const SizedBox(width: 8),
            Icon(service['icon'],
                color: isSelected ? const Color(0xFFDA9C5F) : Colors.white24,
                size: 18),
            const SizedBox(width: 8),
            Text(
              service['label'],
              style: TextStyle(
                color: isSelected ? const Color(0xFFF0E5DB) : Colors.white30,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddImageButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddImageButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFDA9C5F).withOpacity(0.3),
              style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined,
                color: Color(0xFFDA9C5F), size: 28),
            const SizedBox(height: 4),
            Text(
              "Añadir",
              style: TextStyle(
                color: const Color(0xFFDA9C5F).withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePreviewItem extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onDelete;
  const _ImagePreviewItem({required this.imageUrl, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.white10),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final String text;
  const _InfoBanner({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFDA9C5F).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDA9C5F).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb_outline,
              color: Color(0xFFDA9C5F), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style:
                  TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
