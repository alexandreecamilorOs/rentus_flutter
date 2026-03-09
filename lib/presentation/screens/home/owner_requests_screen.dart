// ════════════════════════════════════════════════════════════
// OWNER REQUESTS SCREEN — OWNER VIEW (Solicitudes - Dueño)
// Based on: RequestsView.vue
// Purpose: Show requests FROM tenants wanting to visit MY properties.
//          Owner can: Accept, Reject directly, or Counter-propose a date.
//          After visit accepted+passed: Generate contract.
// ════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/rental_request_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';
import '../../components/app_action_button.dart';
import '../../components/home_navbar.dart';
import '../../components/modern_view_wrapper.dart';

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
        Positioned(
          top: -100,
          right: -100,
          child: _GlowOrb(
              color: const Color(0xFFDA9C5F).withOpacity(0.08), size: 400),
        ),
        Positioned(
          bottom: -150,
          left: -100,
          child: _GlowOrb(
              color: const Color(0xFFDA9C5F).withOpacity(0.05), size: 450),
        ),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}

class OwnerRequestsScreen extends ConsumerStatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  ConsumerState<OwnerRequestsScreen> createState() =>
      _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends ConsumerState<OwnerRequestsScreen> {
  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(ownerRequestsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A0E),
      body: Stack(
        children: [
          const _CinematicBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                Expanded(
                  child: requestsAsync.when(
                    data: (items) => _buildList(items),
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFDA9C5F))),
                    error: (e, _) => Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                color: Colors.redAccent, size: 48),
                            const SizedBox(height: 12),
                            Text(e.toString(),
                                style: const TextStyle(
                                    color: Colors.white60, fontSize: 13),
                                textAlign: TextAlign.center),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Solicitudes (Dueño)",
              onNavigateHome: () => context.go('/home'),
              onNavigateProperties: () => context.go('/properties'),
              onNavigateMap: () => context.go('/map'),
              onNavigateProfile: () => context.go('/profile'),
              onNavigateNotifications: () => context.go('/notifications'),
              onNavigateContracts: () => context.go('/contracts'),
              onNavigatePayments: () => context.go('/payments'),
              onNavigateMaintenance: () => context.go('/maintenance'),
              onNavigateMyRequests: () => context.go('/my_requests'),
              onNavigateRequests: () => context.go('/owner_requests'),
              onNavigateMyReports: () => context.go('/reports'),
              onNavigateSettings: () => context.go('/settings'),
            ),
          ),
        ],
      ),
    ).modernWrapped();
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0x33DA9C5F),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0x1ADA9C5F)),
                ),
                child: const Icon(Icons.home_work_rounded,
                    color: Color(0xFFDA9C5F), size: 28),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "GESTIÓN DE PROPIEDADES",
            style: TextStyle(
              color: const Color(0xFFDA9C5F),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.5,
            ),
          ),
          const Text(
            "Solicitudes",
            style: TextStyle(
              color: Color(0xFFF0E5DB),
              fontSize: 34,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Revisa y gestiona las visitas a tus inmuebles",
            style: TextStyle(
              color: const Color(0xFFF0E5DB).withOpacity(0.4),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<RentalRequest> items) {
    if (items.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFFDA9C5F).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home_work_outlined,
                color: Color(0xFFDA9C5F), size: 56),
          ),
          const SizedBox(height: 20),
          const Text("Sin solicitudes pendientes",
              style: TextStyle(
                  color: Color(0xFFFFF4E8),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Aquí aparecerán las visitas que te soliciten inquilinos.",
              style: TextStyle(color: Color(0xFFD4C5B9), fontSize: 14),
              textAlign: TextAlign.center),
        ],
      );
    }

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemBuilder: (ctx, i) => _buildRequestCard(ctx, items[i]),
    );
  }

  Widget _buildRequestCard(BuildContext context, RentalRequest req) {
    final prop = req.property ?? {};
    final title = prop['title'] ?? 'Propiedad #${req.propertyId}';
    final imageUrl = prop['image_url'] as String?;

    final tenantUser = req.user ?? {};
    final tenantName = tenantUser['name'] ?? 'Inquilino potencial';
    final tenantEmail = tenantUser['email']?.toString() ?? '';
    final tenantPhoto = tenantUser['photo']?.toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1410),
        borderRadius: BorderRadius.circular(28),
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
        borderRadius: BorderRadius.circular(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Banner
            Stack(
              children: [
                if (imageUrl != null && imageUrl.isNotEmpty)
                  SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: Image.network(imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _propertyPlaceholder()),
                  )
                else
                  _propertyPlaceholder(),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _statusBadge(req.status),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          const Color(0xFF1E1410),
                          const Color(0xFF1E1410).withOpacity(0)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tenant Info Area
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0x0AFFFFFF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0x0DFFFFFF)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFDA9C5F), width: 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF2E1D17),
                            backgroundImage:
                                tenantPhoto != null && tenantPhoto.isNotEmpty
                                    ? NetworkImage(tenantPhoto)
                                    : null,
                            child: tenantPhoto == null || tenantPhoto.isEmpty
                                ? const Icon(Icons.person,
                                    color: Color(0xFFDA9C5F), size: 20)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tenantName,
                                  style: const TextStyle(
                                      color: Color(0xFFF0E5DB),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900)),
                              Text(tenantEmail,
                                  style: TextStyle(
                                      color: const Color(0xFFF0E5DB)
                                          .withOpacity(0.4),
                                      fontSize: 11)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date Section
                  Row(
                    children: [
                      _dateChip(Icons.calendar_month_rounded, "SOLICITADA",
                          req.requestedDate, req.requestedTime),
                      if (req.status == 'counter_proposed') ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 14, color: Color(0xFFDA9C5F)),
                        const SizedBox(width: 8),
                        _dateChip(Icons.edit_calendar_rounded, "PROPUESTA",
                            req.counterDate, req.counterTime,
                            color: const Color(0xFFF39C12)),
                      ],
                    ],
                  ),

                  const SizedBox(height: 20),
                  _buildActions(req),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateChip(IconData icon, String label, String? date, String? time,
      {Color color = const Color(0xFFDA9C5F)}) {
    String formatted = 'N/A';
    if (date != null) {
      try {
        formatted = DateFormat('dd MMM', 'es').format(DateTime.parse(date));
      } catch (_) {
        formatted = date;
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: color.withOpacity(0.5),
                      fontSize: 7,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5)),
              Text("$formatted ${time ?? ''}",
                  style: const TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 11,
                      fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _propertyPlaceholder() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xFF8B4513), Color(0xFFDA9C5F)]),
      ),
      child: const Center(
          child: Icon(Icons.home_rounded, color: Colors.white, size: 32)),
    );
  }

  Widget _statusBadge(String status) {
    final map = {
      'pending': ['Pendiente', const Color(0xFF3498DB)],
      'accepted': ['Aceptada', const Color(0xFF2ECC71)],
      'rejected': ['Rechazada', const Color(0xFFE74C3C)],
      'counter_proposed': ['Contraoferta', const Color(0xFFF39C12)],
      'contract_sent': ['Contrato enviado', const Color(0xFF1ABC9C)],
      'visit_completed': ['Completada', const Color(0xFF9B59B6)],
    };
    final info = map[status] ?? [status, const Color(0xFFDA9C5F)];
    final color = info[1] as Color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(info[0] as String,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildActions(RentalRequest req) {
    final repo = ref.read(rentalRequestRepositoryProvider);
    final refresh = () => ref.invalidate(ownerRequestsProvider);

    switch (req.status) {
      case 'pending':
        // Owner can: Review (opens detail sheet), OR reject directly
        return Row(children: [
          Expanded(
            flex: 2,
            child:
                _goldBtn(Icons.search, "Revisar", () => _showReviewModal(req)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: _dangerBtn("Rechazar", () async {
              await repo.rejectRequest(req.id);
              refresh();
            }),
          ),
        ]);

      case 'accepted':
        final visitPassed =
            _isVisitPassed(req.requestedDate, req.requestedTime);
        if (visitPassed) {
          return Row(children: [
            Expanded(
              child: _goldBtn(Icons.check_circle, "Generar Contrato",
                  () => _showContractModal(req)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _dangerBtn("Finalizar", () async {
                await repo.rejectRequest(req.id);
                refresh();
              }),
            ),
          ]);
        } else {
          return _infoMsg(
              Icons.schedule,
              "Visita programada. Esperando la fecha.",
              const Color(0xFF3498DB));
        }

      case 'counter_proposed':
        return _infoMsg(Icons.hourglass_empty,
            "Esperando respuesta del inquilino...", const Color(0xFFF39C12));

      case 'rejected':
        return _infoMsg(Icons.cancel_outlined, "Esta solicitud fue rechazada.",
            const Color(0xFFE74C3C));

      case 'contract_sent':
        return _infoMsg(Icons.description, "Contrato enviado. Esperando firma.",
            const Color(0xFF1ABC9C));

      case 'visit_completed':
        return _infoMsg(Icons.check_circle_outline, "Visita completada.",
            const Color(0xFF9B59B6));

      default:
        return const SizedBox.shrink();
    }
  }

  bool _isVisitPassed(String? date, String? time) {
    if (date == null) return false;
    try {
      var dt = DateTime.parse(date);
      if (time != null && time.isNotEmpty) {
        final parts = time.split(':');
        if (parts.length >= 2) {
          dt = DateTime(dt.year, dt.month, dt.day, int.tryParse(parts[0]) ?? 0,
              int.tryParse(parts[1]) ?? 0);
        }
      }
      return DateTime.now().isAfter(dt);
    } catch (_) {
      return false;
    }
  }

  Widget _goldBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFDA9C5F), Color(0xFFB8791F)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ]),
      ),
    );
  }

  Widget _dangerBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE74C3C).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE74C3C).withOpacity(0.5)),
        ),
        child: Center(
            child: Text(label,
                style: const TextStyle(
                    color: Color(0xFFE74C3C),
                    fontWeight: FontWeight.bold,
                    fontSize: 13))),
      ),
    );
  }

  Widget _infoMsg(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Flexible(
            child: Text(text, style: TextStyle(color: color, fontSize: 13))),
      ]),
    );
  }

  // ── Review Modal (Accept / Counter-offer / Reject) ──────────────────
  void _showReviewModal(RentalRequest req) {
    final tenantUser = req.user ?? {};
    final prop = req.property ?? {};
    bool showCounterForm = false;
    final counterDateCtrl = TextEditingController(
      text: DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 1))),
    );
    final counterTimeCtrl = TextEditingController(text: '10:00');
    final repo = ref.read(rentalRequestRepositoryProvider);
    final refresh = () => ref.invalidate(ownerRequestsProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFF0D0A09),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0x33DA9C5F),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0x33DA9C5F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.search_rounded,
                          color: Color(0xFFDA9C5F)),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Revisar Solicitud",
                      style: TextStyle(
                        color: Color(0xFFF0E5DB),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel("DETALLES INMUEBLE"),
                      _infoCard([
                        _infoItem(
                            "Inmueble", prop['title']?.toString() ?? 'N/A'),
                        _infoItem(
                            "Ubicación", prop['address']?.toString() ?? 'N/A'),
                      ]),
                      const SizedBox(height: 24),
                      _sectionLabel("PERFIL SOLICITANTE"),
                      _infoCard([
                        _infoItem(
                            "Nombre", tenantUser['name']?.toString() ?? 'N/A'),
                        _infoItem(
                            "Email", tenantUser['email']?.toString() ?? 'N/A'),
                        _infoItem("Teléfono",
                            tenantUser['phone']?.toString() ?? 'N/A'),
                      ]),
                      const SizedBox(height: 24),
                      _sectionLabel("FECHA Y HORA"),
                      _infoCard([
                        _infoItem("Fecha", req.requestedDate ?? 'N/A'),
                        _infoItem("Hora", req.requestedTime ?? 'N/A'),
                      ]),
                      const SizedBox(height: 32),
                      AppActionButton(
                        text: "ACEPTAR VISITA",
                        onClick: () async {
                          await repo.acceptRequest(req.id);
                          refresh();
                          if (mounted) Navigator.pop(context);
                        },
                        gradient: const [Color(0xFFDA9C5F), Color(0xFFB87D4A)],
                        contentColor: Colors.black,
                      ),
                      const SizedBox(height: 12),
                      AppActionButton(
                        text: showCounterForm
                            ? "OCULTAR PROPUESTA"
                            : "PROPONER OTRA FECHA",
                        onClick: () =>
                            setModal(() => showCounterForm = !showCounterForm),
                        gradient: [
                          Colors.white.withOpacity(0.05),
                          Colors.white.withOpacity(0.05)
                        ],
                        contentColor: const Color(0xFFDA9C5F),
                      ),
                      if (showCounterForm) ...[
                        const SizedBox(height: 24),
                        _sectionLabel("NUEVA PROPUESTA"),
                        _goldInput("Fecha (YYYY-MM-DD)", counterDateCtrl),
                        const SizedBox(height: 12),
                        _goldInput("Hora (HH:MM)", counterTimeCtrl),
                        const SizedBox(height: 24),
                        AppActionButton(
                          text: "ENVIAR CONTRAOFERTA",
                          onClick: () async {
                            await repo.counterOffer(req.id, {
                              'counter_date': counterDateCtrl.text,
                              'counter_time': '${counterTimeCtrl.text}:00',
                            });
                            refresh();
                            if (mounted) Navigator.pop(context);
                          },
                          gradient: const [
                            Color(0xFFF39C12),
                            Color(0xFFE67E22)
                          ],
                          contentColor: Colors.black,
                        ),
                      ],
                      const SizedBox(height: 12),
                      AppActionButton(
                        text: "RECHAZAR SOLICITUD",
                        onClick: () async {
                          await repo.rejectRequest(req.id);
                          refresh();
                          if (mounted) Navigator.pop(context);
                        },
                        gradient: [
                          Colors.redAccent.withOpacity(0.1),
                          Colors.redAccent.withOpacity(0.1)
                        ],
                        contentColor: Colors.redAccent,
                      ),
                      const SizedBox(height: 48),
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

  // ── Contract Modal ───────────────────────────────────────────────────
  void _showContractModal(RentalRequest req) {
    final prop = req.property ?? {};
    final startCtrl = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
    final endCtrl = TextEditingController(
        text: DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 365))));
    final priceCtrl = TextEditingController(
        text: prop['monthly_rent']?.toString() ??
            prop['monthly_price']?.toString() ??
            '');
    final depositCtrl = TextEditingController(text: '');
    final dayCtrl = TextEditingController(text: '5');
    final repo = ref.read(rentalRequestRepositoryProvider);
    final refresh = () => ref.invalidate(ownerRequestsProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF0D0A09),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0x33DA9C5F),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0x332ECC71),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.description_rounded,
                        color: Color(0xFF2ECC71)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Términos del Contrato",
                    style: TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionLabel("PERÍODO"),
                    _goldInput("Inicio (YYYY-MM-DD)", startCtrl),
                    const SizedBox(height: 12),
                    _goldInput("Fin (YYYY-MM-DD)", endCtrl),
                    const SizedBox(height: 24),
                    _sectionLabel("FINANZAS"),
                    _goldInput("Canon Mensual (\$)", priceCtrl,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _goldInput("Depósito (\$)", depositCtrl,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    _goldInput("Día de pago (1-31)", dayCtrl,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 32),
                    AppActionButton(
                      text: "ENVIAR CONTRATO",
                      onClick: () async {
                        await repo.sendContract(req.id, {
                          'start_date': startCtrl.text,
                          'end_date': endCtrl.text,
                          'monthly_price': double.tryParse(priceCtrl.text) ?? 0,
                          'deposit': double.tryParse(depositCtrl.text) ?? 0,
                          'payment_day': int.tryParse(dayCtrl.text) ?? 5,
                        });
                        refresh();
                        if (mounted) Navigator.pop(context);
                      },
                      gradient: const [Color(0xFF2ECC71), Color(0xFF27AE60)],
                      contentColor: Colors.black,
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                color: Color(0xFFDA9C5F),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6)),
      );

  Widget _infoCard(List<Widget> children) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _infoItem(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$label: ',
              style: const TextStyle(color: Color(0xFFD4C5B9), fontSize: 13)),
          Flexible(
              child: Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600))),
        ]),
      );

  Widget _goldInput(String label, TextEditingController ctrl,
          {TextInputType keyboardType = TextInputType.text}) =>
      TextFormField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFD4C5B9), fontSize: 13),
          filled: true,
          fillColor: Colors.white.withOpacity(0.04),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDA9C5F))),
        ),
      );
}
