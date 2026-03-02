import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';
import '../../components/modern_view_wrapper.dart';
import '../../../data/models/maintenance_model.dart';
import '../../../data/providers/entity_providers.dart';

class MaintenanceItem {
  final int id;
  final String date;
  final String property;
  final String title;
  final String priority;
  final String status;

  MaintenanceItem(this.id, this.date, this.property, this.title, this.priority,
      this.status);
}

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  String _query = "";
  final List<MaintenanceItem> _rows = [
    MaintenanceItem(901, "2026-03-01", "Torre Alta 402", "Fuga en cocina",
        "high", "pending"),
    MaintenanceItem(902, "2026-03-03", "Vista Sol 1301", "Cambio de luminaria",
        "medium", "in_progress"),
    MaintenanceItem(903, "2026-03-05", "Gran Reserva 609",
        "Revisión de cerradura", "low", "completed"),
  ];


  MaintenanceItem _fromMaintenance(Maintenance maintenance) => MaintenanceItem(
        maintenance.id,
        '-',
        'Propiedad ${maintenance.propertyId}',
        maintenance.description,
        'normal',
        maintenance.status,
      );

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(maintenancesProvider);
    final source = dataAsync.maybeWhen(data: (items) => items.map(_fromMaintenance).toList(), orElse: () => _rows);
    final filtered = source
        .where((r) =>
            r.title.toLowerCase().contains(_query.toLowerCase()) ||
            r.property.toLowerCase().contains(_query.toLowerCase()) ||
            r.id.toString().contains(_query))
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
          const _MaintenanceBg(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                if (dataAsync.isLoading) const LinearProgressIndicator(minHeight: 2),
                if (dataAsync.hasError) const Padding(padding: EdgeInsets.only(top: 6), child: Text('Error cargando datos', style: TextStyle(color: Colors.redAccent, fontSize: 11))),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: const Color(0x22DA9C5F),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.build,
                                color: Color(0xFFDA9C5F)),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedHeading(
                                  text: "Mantenimiento",
                                  style: TextStyle(fontSize: 28),
                                  gradientColors: [
                                    Color(0xFFFFF4E8),
                                    Color(0xFFF6D2A5),
                                    Color(0xFFDA9C5F)
                                  ],
                                  durationMillis: 2800),
                              Text("Solicitudes y estado en tiempo real",
                                  style: TextStyle(
                                      color: Color(0xFFD4C5B9), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppActionButton(
                              text: "Nueva solicitud",
                              onClick: () {},
                              contentColor: const Color(0xFF1A0E0A),
                              gradient: const [
                                Color(0xFFDA9C5F),
                                Color(0xFFB8791F),
                                Color(0xFFDA9C5F)
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppActionButton(
                              text: "Pendientes",
                              onClick: () {},
                              gradient: const [
                                Color(0xFF3B251D),
                                Color(0xFF4D2F24),
                                Color(0xFF6C4531)
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
                          hintText: "Buscar por propiedad o id",
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
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 84, top: 4),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final row = filtered[index];
                      Color statusColor = const Color(0xFF2ECC71);
                      if (row.status == "pending")
                        statusColor = const Color(0xFFF59E0B);
                      if (row.status == "in_progress")
                        statusColor = const Color(0xFF93C5FD);

                      Color priorityColor = const Color(0xFFA0AEC0);
                      if (row.priority == "high")
                        priorityColor = const Color(0xFFE74C3C);
                      if (row.priority == "medium")
                        priorityColor = const Color(0xFFF59E0B);

                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xF23A2318),
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("#${row.id}",
                                    style: const TextStyle(
                                        color: Color(0xFFDA9C5F),
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Text(row.date,
                                    style: const TextStyle(
                                        color: Color(0xFFD4C5B9),
                                        fontSize: 12)),
                                const Spacer(),
                                Text(row.status.toUpperCase(),
                                    style: TextStyle(
                                        color: statusColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(row.property,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                            Text(row.title,
                                style:
                                    const TextStyle(color: Color(0xFFE5D6C8))),
                            const SizedBox(height: 4),
                            Text("Prioridad: ${row.priority}",
                                style: TextStyle(
                                    color: priorityColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
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
        ],
      ),
    ).modernWrapped();
  }
}

class _MaintenanceBg extends StatefulWidget {
  const _MaintenanceBg();
  @override
  State<_MaintenanceBg> createState() => _MaintenanceBgState();
}

class _MaintenanceBgState extends State<_MaintenanceBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Stack(
          children: List.generate(10, (i) {
            return Positioned(
              left: (i * 34.0),
              top: 70.0 + (i * 45.0) + (_ctrl.value * -15.0),
              child: Container(
                width: 4.0 + (i % 2),
                height: 4.0 + (i % 2),
                decoration: const BoxDecoration(
                    color: Color(0x44DA9C5F), shape: BoxShape.circle),
              ),
            );
          }),
        );
      },
    );
  }
}
