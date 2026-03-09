// ════════════════════════════════════════════════════════════
// MY REQUESTS SCREEN — TENANT VIEW (Mis Solicitudes)
// Based on: MyRequestsModal.vue
// Purpose: Show MY requests to visit properties I want to rent.
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
          left: -100,
          child: _GlowOrb(
              color: const Color(0xFF9B59B6).withOpacity(0.08), size: 400),
        ),
        Positioned(
          bottom: -150,
          right: -100,
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

class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(myRequestsProvider);

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
                    data: (items) => _buildList(context, ref, items),
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFFDA9C5F))),
                    error: (e, _) => _buildError(e.toString()),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Mis Solicitudes",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PENDIENTES",
                    style: TextStyle(
                      color: const Color(0xFFDA9C5F).withOpacity(0.6),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const Text(
                    "Mis Solicitudes",
                    style: TextStyle(
                      color: Color(0xFFF0E5DB),
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFDA9C5F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: const Color(0xFFDA9C5F).withOpacity(0.2)),
                ),
                child: const Icon(Icons.calendar_month_rounded,
                    color: Color(0xFFDA9C5F), size: 24),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          Text(error,
              style: const TextStyle(color: Colors.white60, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildList(
      BuildContext context, WidgetRef ref, List<RentalRequest> items) {
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
          const Text("Sin solicitudes activas",
              style: TextStyle(
                  color: Color(0xFFFFF4E8),
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text("Cuando solicites visitar una propiedad, aparecerá aquí.",
              style: TextStyle(color: Color(0xFFD4C5B9), fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: AppActionButton(
              text: "DESCUBRIR PROPIEDADES",
              onClick: () => context.go('/properties'),
              gradient: const [Color(0xFFDA9C5F), Color(0xFFB8791F)],
              contentColor: Colors.black,
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemBuilder: (ctx, i) => _buildRequestCard(ctx, ref, items[i]),
    );
  }

  Widget _buildRequestCard(
      BuildContext context, WidgetRef ref, RentalRequest req) {
    final prop = req.property ?? {};
    final title = prop['title'] ?? 'Propiedad #${req.propertyId}';
    final address = prop['address'] ?? '';
    final imageUrl = prop['image_url'] as String?;

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
            // Image Section
            Stack(
              children: [
                if (imageUrl != null && imageUrl.isNotEmpty)
                  SizedBox(
                    height: 140,
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
                    height: 50,
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
                  Text(title,
                      style: const TextStyle(
                          color: Color(0xFFF0E5DB),
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  if (address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.location_on,
                          color: Color(0xFFDA9C5F), size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                          child: Text(address,
                              style: TextStyle(
                                  color:
                                      const Color(0xFFF0E5DB).withOpacity(0.4),
                                  fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                  const SizedBox(height: 16),

                  // Dates
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

                  // Actions
                  _buildStatusAndActions(context, ref, req),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _propertyPlaceholder() {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xFF2E1D17), Color(0xFF1E1410)]),
      ),
      child: const Center(
          child: Icon(Icons.home_rounded, color: Color(0xFFDA9C5F), size: 40)),
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

  Widget _buildStatusAndActions(
      BuildContext context, WidgetRef ref, RentalRequest req) {
    final repo = ref.read(rentalRequestRepositoryProvider);
    final refresh = () => ref.invalidate(myRequestsProvider);

    switch (req.status) {
      case 'counter_proposed':
        return Row(children: [
          Expanded(
            child: AppActionButton(
              text: "ACEPTAR",
              onClick: () async {
                await repo.acceptCounter(req.id);
                refresh();
              },
              gradient: const [Color(0xFF2ECC71), Color(0xFF27AE60)],
              contentColor: Colors.black,
              height: 44,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppActionButton(
              text: "RECHAZAR",
              onClick: () async {
                await repo.rejectCounter(req.id);
                refresh();
              },
              gradient: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.05)
              ],
              contentColor: Colors.redAccent,
              height: 44,
            ),
          ),
        ]);

      case 'accepted':
        return _infoMessage(Icons.stars_rounded,
            "Visita confirmada. ¡Te esperamos!", const Color(0xFF2ECC71));

      case 'contract_sent':
        return AppActionButton(
          text: "REVISAR CONTRATO",
          onClick: () => context.go('/contracts'),
          gradient: const [Color(0xFFDA9C5F), Color(0xFFB87D4A)],
          contentColor: Colors.black,
        );

      case 'rejected':
        return _infoMessage(Icons.cancel_outlined,
            "Esta solicitud fue rechazada.", const Color(0xFFE74C3C));

      case 'pending':
        return Column(children: [
          _infoMessage(Icons.hourglass_empty_rounded,
              "Esperando respuesta del dueño...", const Color(0xFFF39C12)),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              await repo.cancelRequest(req.id);
              refresh();
            },
            child: Text(
              "CANCELAR SOLICITUD",
              style: TextStyle(
                  color: Colors.redAccent.withOpacity(0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1),
            ),
          ),
        ]);

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _statusBadge(String status) {
    final map = {
      'pending': ['Pendiente', const Color(0xFFF39C12)],
      'accepted': ['Aceptada', const Color(0xFF2ECC71)],
      'rejected': ['Rechazada', const Color(0xFFE74C3C)],
      'counter_proposed': ['Contraoferta', const Color(0xFFF39C12)],
      'contract_sent': ['Contrato enviado', const Color(0xFF3498DB)],
      'visit_completed': ['Visita completada', const Color(0xFF9B59B6)],
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

  Widget _infoMessage(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
            child: Text(text,
                style: TextStyle(
                    color: color, fontSize: 13, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
