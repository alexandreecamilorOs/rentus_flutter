import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/report_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';
import '../../components/app_action_button.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(reportsProvider);

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
                            icon: Icons.add_moderator_rounded,
                            onTap: () => _showNewReportModal(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "SEGUIMIENTO Y SEGURIDAD",
                        style: TextStyle(
                          color: const Color(0xFFDA9C5F),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const Text(
                        "Mis Reportes",
                        style: TextStyle(
                          color: Color(0xFFF0E5DB),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Historial de quejas, reclamos y seguridad",
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
                  child: reportsAsync.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const _EmptyReports(
                            key: ValueKey('empty_reports'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _ReportCard(report: items[index]),
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

  void _showNewReportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1412),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _NewReportSheet(),
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
          top: -100,
          right: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.08),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -150,
          left: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.05),
            size: 450,
          ),
        ),
        const _CinematicParticles(),
      ],
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

class _ReportCard extends StatelessWidget {
  final Report report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    final status = report.status.toLowerCase();

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE74C3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: const Color(0xFFE74C3C).withOpacity(0.2)),
                    ),
                    child: const Icon(Icons.report_problem_rounded,
                        color: Color(0xFFE74C3C), size: 24),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "REF: #${report.id}",
                              style: TextStyle(
                                color: const Color(0xFFF0E5DB).withOpacity(0.3),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            _StatusBadge(status: status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          report.title,
                          style: const TextStyle(
                            color: Color(0xFFDA9C5F),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.description,
                          style: const TextStyle(
                            color: Color(0xFFF0E5DB),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 12,
                                color:
                                    const Color(0xFFF0E5DB).withOpacity(0.4)),
                            const SizedBox(width: 4),
                            Text(
                              "Enviado recientemente",
                              style: TextStyle(
                                color: const Color(0xFFF0E5DB).withOpacity(0.4),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
    if (status.contains('pending')) return const Color(0xFFDA9C5F);
    if (status.contains('resolved')) return Colors.greenAccent;
    return Colors.blueGrey;
  }
}

class _NewReportSheet extends ConsumerStatefulWidget {
  const _NewReportSheet();

  @override
  ConsumerState<_NewReportSheet> createState() => _NewReportSheetState();
}

class _NewReportSheetState extends ConsumerState<_NewReportSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    "NUEVO REPORTE",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0),
                  ),
                  Text(
                    "Seguridad y Quejas",
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
          _formLabel("ASUNTO DEL REPORTE"),
          _formField(
              _titleController, "Ej: Ruido excesivo, Seguridad nocturna..."),
          const SizedBox(height: 24),
          _formLabel("DETALLES INCIDENTE"),
          _formField(_descriptionController,
              "Proporciona toda la información relevante...",
              maxLines: 4),
          const SizedBox(height: 32),
          AppActionButton(
            text: _isLoading ? "PROCESANDO..." : "ENVIAR REPORTE",
            onClick: _handleSend,
            gradient: const [Color(0xFFDA9C5F), Color(0xFFB87D4A)],
            contentColor: Colors.black,
            isEnabled: !_isLoading &&
                _titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _formLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label,
          style: const TextStyle(
              color: Color(0xFFDA9C5F),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0)),
    );
  }

  Widget _formField(TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFFF0E5DB), fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
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
      onChanged: (_) => setState(() {}),
    );
  }

  Future<void> _handleSend() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(reportRepositoryProvider).createReport({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'status': 'pending',
      });
      if (mounted) {
        context.pop();
        ref.invalidate(reportsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Reporte enviado correctamente."),
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

class _EmptyReports extends StatelessWidget {
  const _EmptyReports({super.key});

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
            child: const Icon(Icons.shield_rounded,
                size: 64, color: Color(0xFFDA9C5F)),
          ),
          const SizedBox(height: 24),
          const Text(
            "Sin novedades",
            style: TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            "Tu historial de reportes y seguridad aparecerá aquí.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
