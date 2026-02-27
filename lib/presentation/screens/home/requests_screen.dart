import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';

class OwnerRequest {
  final int id;
  final String propertyTitle;
  final String address;
  final String tenantName;
  final String requestedDate;
  final String requestedTime;
  final String status;

  OwnerRequest(this.id, this.propertyTitle, this.address, this.tenantName,
      this.requestedDate, this.requestedTime, this.status);
}

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  OwnerRequest? _selected;
  final List<OwnerRequest> _requests = [
    OwnerRequest(9001, "Penthouse Sky Lounge", "Bogotá, Chapinero",
        "Laura Mejía", "2026-04-10", "10:00", "pending"),
    OwnerRequest(9002, "Casa Forest Minimal", "Medellín, Laureles",
        "Andrés Ruiz", "2026-04-11", "15:30", "counter_proposed"),
    OwnerRequest(9003, "Loft Neon District", "Cali, Oeste", "Valentina Peña",
        "2026-04-13", "09:15", "accepted"),
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
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xFFDA9C5F), Color(0xFFB8791F)]),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.home, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedHeading(
                                text: "Solicitudes (Dueño)",
                                style: TextStyle(fontSize: 24),
                                gradientColors: [
                                  Color(0xFFFFF4E8),
                                  Color(0xFFF6D2A5),
                                  Color(0xFFDA9C5F)
                                ],
                                durationMillis: 2800),
                            Text(
                                "Administra visitas recibidas para tus propiedades",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, top: 14, bottom: 84),
                    itemCount: _requests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final req = _requests[index];
                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFFDFBF8),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2))
                            ]),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.image,
                                  size: 48, color: Colors.white24),
                            ),
                            const SizedBox(height: 8),
                            AnimatedHeading(
                                text: req.propertyTitle,
                                style: const TextStyle(fontSize: 18),
                                gradientColors: const [
                                  Color(0xFF2E1D17),
                                  Color(0xFF8A5D34),
                                  Color(0xFFDA9C5F)
                                ],
                                durationMillis: 2900),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFFDA9C5F), size: 14),
                                const SizedBox(width: 4),
                                Text(req.address,
                                    style: const TextStyle(
                                        color: Color(0xFF5E5E5E),
                                        fontSize: 12)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.person,
                                    color: Color(0xFF7A5A45), size: 14),
                                const SizedBox(width: 4),
                                Text(req.tenantName,
                                    style: const TextStyle(
                                        color: Color(0xFF374151),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    color: Color(0xFF7A5A45), size: 13),
                                const SizedBox(width: 4),
                                Text(
                                    "${req.requestedDate} · ${req.requestedTime}",
                                    style: const TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: AppActionButton(
                                    text: "Revisar",
                                    onClick: () =>
                                        setState(() => _selected = req),
                                    gradient: const [
                                      Color(0xFF3498DB),
                                      Color(0xFF2980B9),
                                      Color(0xFF3498DB)
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppActionButton(
                                    text: "Rechazar",
                                    onClick: () {},
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
          if (_selected != null)
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
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AnimatedHeading(
                              text: "Revisar Solicitud",
                              style: TextStyle(fontSize: 22),
                              gradientColors: [
                                Color(0xFF2E1D17),
                                Color(0xFF8A5D34),
                                Color(0xFFDA9C5F)
                              ],
                              durationMillis: 2800),
                          const SizedBox(height: 10),
                          Text(
                              "${_selected!.tenantName} quiere visitar ${_selected!.propertyTitle}",
                              style: const TextStyle(color: Color(0xFF4B5563))),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: AppActionButton(
                                  text: "Aceptar",
                                  onClick: () =>
                                      setState(() => _selected = null),
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
                                  text: "Proponer fecha",
                                  onClick: () {},
                                  gradient: const [
                                    Color(0xFFF39C12),
                                    Color(0xFFE67E22),
                                    Color(0xFFF39C12)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AppActionButton(
                            text: "Enviar contrato",
                            onClick: () => setState(() => _selected = null),
                            gradient: const [
                              Color(0xFF27AE60),
                              Color(0xFF229954),
                              Color(0xFF27AE60)
                            ],
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton(
                                onPressed: () =>
                                    setState(() => _selected = null),
                                child: const Text("Cerrar")),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
