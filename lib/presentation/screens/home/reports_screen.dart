import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';
import '../../components/modern_view_wrapper.dart';
import '../../../data/models/report_model.dart';
import '../../../data/providers/entity_providers.dart';

class ReportItem {
  final int id;
  final String date;
  final String type;
  final String detail;
  final String status;

  ReportItem(this.id, this.date, this.type, this.detail, this.status);
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  bool _showCreate = false;
  String _query = "";
  final List<ReportItem> _reports = [
    ReportItem(501, "2026-04-02", "Propiedad",
        "Publicación con datos incompletos", "pending"),
    ReportItem(502, "2026-04-01", "Usuario",
        "Comportamiento inapropiado en chat", "reviewed"),
    ReportItem(503, "2026-03-28", "Reseña", "Contenido ofensivo", "resolved"),
  ];


  ReportItem _fromReport(Report report) => ReportItem(
        report.id,
        '-',
        report.title,
        report.description,
        report.status,
      );

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(reportsProvider);
    final source = dataAsync.maybeWhen(data: (items) => items.map(_fromReport).toList(), orElse: () => _reports);
    final filtered = source
        .where((r) =>
            r.detail.toLowerCase().contains(_query.toLowerCase()) ||
            r.type.toLowerCase().contains(_query.toLowerCase()))
        .toList();

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
            child: Column(
              children: [
                if (dataAsync.isLoading) const LinearProgressIndicator(minHeight: 2),
                if (dataAsync.hasError) const Padding(padding: EdgeInsets.only(top: 6), child: Text('Error cargando datos', style: TextStyle(color: Colors.redAccent, fontSize: 11))),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 18, bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("MIS REPORTES",
                                    style: TextStyle(
                                        color: Color(0xFFDA9C5F),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                                AnimatedHeading(
                                    text: "Reportes y Quejas",
                                    style: TextStyle(fontSize: 30),
                                    gradientColors: [
                                      Color(0xFFFFF4E8),
                                      Color(0xFFF6D2A5),
                                      Color(0xFFDA9C5F)
                                    ],
                                    durationMillis: 2800),
                                Text(
                                    "Haz seguimiento al estado de tus reportes.",
                                    style: TextStyle(
                                        color: Color(0xFFD4C5B9),
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: AppActionButton(
                              text: "Nuevo",
                              onClick: () => setState(() => _showCreate = true),
                              gradient: const [
                                Color(0xFFDA9C5F),
                                Color(0xFFB8791F),
                                Color(0xFFDA9C5F)
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        onChanged: (val) => setState(() => _query = val),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Buscar en mis reportes",
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: const Color(0x22FFFFFF),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 84),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final row = filtered[index];
                      Color statusColor = const Color(0xFFF59E0B);
                      if (row.status == "resolved")
                        statusColor = const Color(0xFF2ECC71);
                      if (row.status == "reviewed")
                        statusColor = const Color(0xFF6366F1);
                      if (row.status == "dismissed")
                        statusColor = const Color(0xFF718096);

                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFFDFBF8),
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            const Icon(Icons.bug_report,
                                color: Color(0xFFDA9C5F)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("#${row.id} · ${row.type}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2C3E50))),
                                  Text(row.detail,
                                      style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 12)),
                                  Text(row.date,
                                      style: const TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Text(row.status.toUpperCase(),
                                  style: TextStyle(
                                      color: statusColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "",
              onNavigateHome: () => context.go('/home'),
              onNavigateProperties: () => context.go('/properties'),
              onNavigateAbout: () => context.go('/about'),
              onNavigateProfile: () => context.go('/profile'),
              onNavigateNotifications: () => context.go('/notifications'),
              onNavigateContracts: () => context.go('/contracts'),
              onNavigatePayments: () => context.go('/payments'),
              onNavigateMaintenance: () => context.go('/maintenance'),
              onNavigateMyRequests: () => context.go('/requests'),
              onNavigateRequests: () => context.go('/requests'),
              onNavigateMyReports: () => context.go('/reports'),
              onNavigateSettings: () => context.go('/settings'),
            ),
          ),
          if (_showCreate)
            Container(
              color: Colors.black54,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18)),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AnimatedHeading(
                              text: "Nuevo reporte",
                              style: TextStyle(fontSize: 22),
                              gradientColors: [
                                Color(0xFF2E1D17),
                                Color(0xFF8A5D34),
                                Color(0xFFDA9C5F)
                              ],
                              durationMillis: 2800),
                          const SizedBox(height: 10),
                          TextField(
                            decoration: InputDecoration(
                                hintText: "Describe el reporte",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10)),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: AppActionButton(
                                  text: "Enviar",
                                  onClick: () =>
                                      setState(() => _showCreate = false),
                                  gradient: const [
                                    Color(0xFF2ECC71),
                                    Color(0xFF27AE60),
                                    Color(0xFF2ECC71)
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppActionButton(
                                  text: "Cancelar",
                                  onClick: () =>
                                      setState(() => _showCreate = false),
                                  gradient: const [
                                    Color(0xFFE74C3C),
                                    Color(0xFFC0392B),
                                    Color(0xFFE74C3C)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    ).modernWrapped();
  }
}
