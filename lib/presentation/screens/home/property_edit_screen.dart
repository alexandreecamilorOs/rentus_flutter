import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';
import '../../components/app_action_button.dart';

class PropertyEditScreen extends ConsumerStatefulWidget {
  const PropertyEditScreen({super.key, required this.propertyId});
  final int propertyId;

  @override
  ConsumerState<PropertyEditScreen> createState() => _PropertyEditScreenState();
}

class _PropertyEditScreenState extends ConsumerState<PropertyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _initialized = false;

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();
  final _areaController = TextEditingController();

  String _selectedType = 'Casa';
  String _selectedBusinessType = 'Renta';
  bool _isSaving = false;

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
    super.dispose();
  }

  void _initializeData(dynamic property) {
    if (_initialized) return;
    _titleController.text = property.title;
    _descriptionController.text = property.description;
    _cityController.text = property.city;
    _addressController.text = property.address ?? '';
    _priceController.text = property.price?.toString() ?? '0';
    _bedroomsController.text = property.numBedrooms?.toString() ?? '';
    _bathroomsController.text = property.numBathrooms?.toString() ?? '';
    _areaController.text = property.area?.toString() ?? '';

    // Attempt to match dropdown values
    if (['casa', 'apartamento', 'oficina', 'local']
        .contains(property.type?.toLowerCase())) {
      _selectedType = property.type![0].toUpperCase() +
          property.type!.substring(1).toLowerCase();
    }
    if (['renta', 'venta'].contains(property.businessType?.toLowerCase())) {
      _selectedBusinessType = property.businessType![0].toUpperCase() +
          property.businessType!.substring(1).toLowerCase();
    }

    _initialized = true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final repository = ref.read(propertyRepositoryProvider);
      await repository.updateProperty(widget.propertyId, {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'city': _cityController.text,
        'address': _addressController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'type': _selectedType.toLowerCase(),
        'business_type': _selectedBusinessType.toLowerCase(),
        'num_bedrooms': int.tryParse(_bedroomsController.text),
        'num_bathrooms': int.tryParse(_bathroomsController.text),
        'area': double.tryParse(_areaController.text),
      });

      // Invalidate detail to refresh
      ref.invalidate(propertyDetailProvider(widget.propertyId));
      ref.invalidate(propertyListProvider);

      if (!mounted) return;
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Propiedad actualizada con éxito!'),
          backgroundColor: Color(0xFF27AE60),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: const Color(0xFFE74C3C),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(propertyDetailProvider(widget.propertyId));

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          const _CinematicBackground(),
          SafeArea(
            child: Column(
              children: [
                _Header(onBack: () => context.pop()),
                Expanded(
                  child: detailAsync.when(
                    data: (property) {
                      _initializeData(property);
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const _SectionTitle(
                                  title: "Información Básica",
                                  icon: Icons.info_outline),
                              const SizedBox(height: 20),
                              _LuxuryTextField(
                                controller: _titleController,
                                label: "Título de la Propiedad",
                                hint: "Ej: Residencia Moderna",
                                validator: (v) =>
                                    v!.isEmpty ? "Requerido" : null,
                              ),
                              const SizedBox(height: 20),
                              _LuxuryTextField(
                                controller: _descriptionController,
                                label: "Descripción",
                                hint: "Describe los detalles...",
                                maxLines: 4,
                                validator: (v) =>
                                    v!.isEmpty ? "Requerido" : null,
                              ),
                              const SizedBox(height: 32),
                              const _SectionTitle(
                                  title: "Categoría y Negocio",
                                  icon: Icons.category_outlined),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _LuxuryDropdown(
                                      label: "Tipo",
                                      value: _selectedType,
                                      items: const [
                                        'Casa',
                                        'Apartamento',
                                        'Oficina',
                                        'Local'
                                      ],
                                      onChanged: (v) =>
                                          setState(() => _selectedType = v!),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _LuxuryDropdown(
                                      label: "Acuerdo",
                                      value: _selectedBusinessType,
                                      items: const ['Renta', 'Venta'],
                                      onChanged: (v) => setState(
                                          () => _selectedBusinessType = v!),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              const _SectionTitle(
                                  title: "Ubicación y Precio",
                                  icon: Icons.location_on_outlined),
                              const SizedBox(height: 20),
                              _LuxuryTextField(
                                controller: _cityController,
                                label: "Ciudad",
                                hint: "Ej: Medellín",
                                validator: (v) =>
                                    v!.isEmpty ? "Requerido" : null,
                              ),
                              const SizedBox(height: 20),
                              _LuxuryTextField(
                                controller: _addressController,
                                label: "Dirección",
                                hint: "Calle o zona específica",
                              ),
                              const SizedBox(height: 20),
                              _LuxuryTextField(
                                controller: _priceController,
                                label: "Precio Mensual / Total",
                                hint: "0.00",
                                keyboardType: TextInputType.number,
                                prefix: const Text("\$ ",
                                    style: TextStyle(color: Color(0xFFDA9C5F))),
                                validator: (v) =>
                                    v!.isEmpty ? "Requerido" : null,
                              ),
                              const SizedBox(height: 32),
                              const _SectionTitle(
                                  title: "Características",
                                  icon: Icons.meeting_room_outlined),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _LuxuryTextField(
                                      controller: _bedroomsController,
                                      label: "Habitaciones",
                                      hint: "0",
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _LuxuryTextField(
                                      controller: _bathroomsController,
                                      label: "Baños",
                                      hint: "0",
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _LuxuryTextField(
                                controller: _areaController,
                                label: "Área (m²)",
                                hint: "0.00",
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 48),
                              _isSaving
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Color(0xFFDA9C5F)))
                                  : AppActionButton(
                                      text: "Guardar Cambios",
                                      onClick: _submit,
                                      gradient: const [
                                        Color(0xFFDA9C5F),
                                        Color(0xFFB8791F)
                                      ],
                                      contentColor: const Color(0xFF1A0E0A),
                                    ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFDA9C5F))),
                    error: (err, _) => Center(
                      child: Text("Error: $err",
                          style: const TextStyle(color: Colors.redAccent)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Reused components from Create Screen (Same as previous file)
class _CinematicBackground extends StatelessWidget {
  const _CinematicBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D0A09),
            Color(0xFF1E1410),
            Color(0xFF2E1D17),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onBack;
  const _Header({required this.onBack});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Color(0xFFDA9C5F), size: 20)),
          const Text("Editar Propiedad",
              style: TextStyle(
                  color: Color(0xFFF0E5DB),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFDA9C5F), size: 20),
        const SizedBox(width: 10),
        Text(title.toUpperCase(),
            style: TextStyle(
                color: const Color(0xFFDA9C5F).withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5)),
      ],
    );
  }
}

class _LuxuryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;
  final Widget? prefix;
  final String? Function(String?)? validator;
  const _LuxuryTextField(
      {required this.controller,
      required this.label,
      required this.hint,
      this.maxLines = 1,
      this.keyboardType = TextInputType.text,
      this.prefix,
      this.validator});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08))),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(color: Color(0xFFF0E5DB)),
            cursorColor: const Color(0xFFDA9C5F),
            decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.15)),
                prefix: prefix,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16)),
          ),
        ),
      ],
    );
  }
}

class _LuxuryDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
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
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.08))),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFF1E1410),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFFDA9C5F)),
              isExpanded: true,
              style: const TextStyle(color: Color(0xFFF0E5DB)),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
