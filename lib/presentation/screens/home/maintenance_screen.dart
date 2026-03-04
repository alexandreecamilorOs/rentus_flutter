import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/maintenance_model.dart';
import '../../../data/models/property_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';
import '../../components/app_action_button.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maintenancesAsync = ref.watch(maintenancesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A09),
      body: Stack(
        children: [
          const _CinematicBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0x33DA9C5F),
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: const Color(0x1ADA9C5F)),
                              ),
                              child: const Icon(Icons.chevron_left_rounded,
                                  color: Color(0xFFDA9C5F), size: 28),
                            ),
                          ),
                          _HeaderAction(
                            icon: Icons.add_comment_rounded,
                            onTap: () => _showReportIssueModal(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "ASISTENCIA TÉCNICA",
                        style: TextStyle(
                          color: const Color(0xFFDA9C5F),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const Text(
                        "Mantenimiento",
                        style: TextStyle(
                          color: Color(0xFFF0E5DB),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Reporta y haz seguimiento a tus solicitudes",
                        style: TextStyle(
                          color: const Color(0xFFF0E5DB).withOpacity(0.4),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: maintenancesAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const _EmptyMaintenances(
                            key: ValueKey('empty_maintenances'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _MaintenanceCard(item: items[index]),
                      );
                    },
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFDA9C5F))),
                    error: (e, s) => Center(
                        child: Text("Error: $e",
                            style: const TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportIssueModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1412),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _ReportIssueSheet(),
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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D0A09), Color(0xFF140F0D), Color(0xFF1A1412)],
            ),
          ),
        ),
        // Glow Orbs
        Positioned(
          top: -150,
          left: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.08),
            size: 400,
          ),
        ),
        Positioned(
          bottom: 100,
          right: -150,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.04),
            size: 350,
          ),
        ),
        const _CinematicParticles(),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }
}

class _CinematicParticles extends StatefulWidget {
  const _CinematicParticles();

  @override
  State<_CinematicParticles> createState() => _CinematicParticlesState();
}

class _CinematicParticlesState extends State<_CinematicParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlesPainter(phase: _controller.value),
          child: Container(),
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double phase;
  _ParticlesPainter({required this.phase});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 40; i++) {
      double x = (i * 137 + phase * 50) % w;
      double y = (i * 223 - phase * 80) % h;
      if (y < 0) y += h;

      paint.color = Colors.white.withOpacity(0.05 + (i % 5) * 0.01);
      canvas.drawCircle(Offset(x, y), 0.5 + (i % 2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.phase != phase;
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderAction({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFDA9C5F).withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFDA9C5F).withOpacity(0.2)),
        ),
        child: Icon(icon, color: const Color(0xFFDA9C5F), size: 20),
      ),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final Maintenance item;

  const _MaintenanceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final status = item.status.toLowerCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1410),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1ADA9C5F)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusBadge(status: status),
                      Text(
                        "REF: #${item.id}",
                        style: TextStyle(
                          color: const Color(0xFFF0E5DB).withOpacity(0.3),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x33DA9C5F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.home_work_rounded,
                            size: 14, color: Color(0xFFDA9C5F)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PROPIEDAD",
                            style: TextStyle(
                              color: const Color(0xFFF0E5DB).withOpacity(0.4),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Propiedad #${item.propertyId}",
                            style: const TextStyle(
                              color: Color(0xFFF0E5DB),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          color: const Color(0xFFDA9C5F).withOpacity(0.3)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFDA9C5F);
      case 'in_progress':
        return Colors.blueAccent;
      case 'resolved':
        return Colors.greenAccent;
      case 'completed':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }
}

class _ReportIssueSheet extends ConsumerStatefulWidget {
  const _ReportIssueSheet();

  @override
  ConsumerState<_ReportIssueSheet> createState() => _ReportIssueSheetState();
}

class _ReportIssueSheetState extends ConsumerState<_ReportIssueSheet> {
  final _descriptionController = TextEditingController();
  Property? _selectedProperty;
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertiesAsync = ref.watch(myPropertiesProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0A09),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0x33DA9C5F),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NUEVO REQUERIMIENTO",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0),
                  ),
                  Text(
                    "Reportar Problema",
                    style: TextStyle(
                        color: Color(0xFFF0E5DB),
                        fontSize: 24,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close_rounded, color: Color(0xFFDA9C5F)),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Property Selector
          const Text("PROPIEDAD AFECTADA",
              style: TextStyle(
                  color: Color(0xFFDA9C5F),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0)),
          const SizedBox(height: 12),
          propertiesAsync.when(
            data: (properties) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0x0AFFFFFF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0x1AFFFFFF)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Property>(
                  value: _selectedProperty,
                  dropdownColor: const Color(0xFF1E1410),
                  hint: const Text("Selecciona la propiedad",
                      style: TextStyle(color: Colors.white24, fontSize: 14)),
                  isExpanded: true,
                  style: const TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                  items: properties
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.title),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedProperty = v),
                ),
              ),
            ),
            loading: () =>
                const LinearProgressIndicator(color: Color(0xFFDA9C5F)),
            error: (e, s) => const Text("Error al cargar propiedades",
                style: TextStyle(color: Colors.redAccent)),
          ),

          const SizedBox(height: 24),

          // Description
          const Text("DESCRIPCIÓN DETALLADA",
              style: TextStyle(
                  color: Color(0xFFDA9C5F),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0)),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            style: const TextStyle(color: Color(0xFFF0E5DB), fontSize: 15),
            decoration: InputDecoration(
              hintText: "¿Qué está sucediendo? Cuéntanos los detalles...",
              hintStyle: const TextStyle(color: Colors.white24),
              filled: true,
              fillColor: const Color(0x0AFFFFFF),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0x1AFFFFFF))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFDA9C5F))),
              contentPadding: const EdgeInsets.all(20),
            ),
          ),

          const SizedBox(height: 32),
          AppActionButton(
            text: _isLoading ? "ENVIANDO..." : "ENVIAR REQUERIMIENTO",
            onClick: _handleReport,
            gradient: const [Color(0xFFDA9C5F), Color(0xFFB87D4A)],
            contentColor: Colors.black,
            isEnabled: !_isLoading &&
                _selectedProperty != null &&
                _descriptionController.text.isNotEmpty,
          ),
        ],
      ),
    );
  }

  Future<void> _handleReport() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(maintenanceRepositoryProvider).createMaintenance({
        'property_id': _selectedProperty!.id,
        'description': _descriptionController.text,
        'status': 'pending',
      });
      if (mounted) {
        context.pop();
        ref.invalidate(maintenancesProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Reporte enviado con éxito."),
              backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class _EmptyMaintenances extends StatelessWidget {
  const _EmptyMaintenances({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0x0AFFFFFF),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0x1ADA9C5F)),
            ),
            child: const Icon(Icons.build_circle_rounded,
                size: 64, color: Color(0xFFDA9C5F)),
          ),
          const SizedBox(height: 24),
          const Text(
            "Todo bajo control",
            style: TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            "No tienes solicitudes de mantenimiento activas.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
