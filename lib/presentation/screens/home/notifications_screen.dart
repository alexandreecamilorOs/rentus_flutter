import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final String type;
  bool read;

  NotificationItem(this.title, this.body, this.time, this.type, this.read);
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
        "Nuevo contrato",
        "Tu contrato #212 está listo para revisión.",
        "Hace 5 min",
        "warning",
        false),
    NotificationItem(
        "Pago recibido",
        "Recibiste un pago de arriendo exitosamente.",
        "Hace 30 min",
        "success",
        true),
    NotificationItem("Mantenimiento", "Se creó una solicitud para Apto 402.",
        "Hoy 09:20", "info", false),
  ];

  @override
  Widget build(BuildContext context) {
    int unreadCount = _notifications.where((n) => !n.read).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      body: Stack(
        children: [
          const _NotificationsBackground(),
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
                        child: const Icon(Icons.notifications,
                            color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AnimatedHeading(
                                text: "Notificaciones",
                                style: TextStyle(fontSize: 22),
                                gradientColors: [
                                  Color(0xFFFFF4E8),
                                  Color(0xFFF6D2A5),
                                  Color(0xFFDA9C5F)
                                ],
                                durationMillis: 2800),
                            Text("$unreadCount sin leer",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (unreadCount > 0)
                        SizedBox(
                          width: 120,
                          child: AppActionButton(
                            text: "Marcar todo",
                            onClick: () {
                              setState(() {
                                for (var n in _notifications) {
                                  n.read = true;
                                }
                              });
                            },
                            gradient: const [
                              Colors.white,
                              Color(0xFFF9E9D4),
                              Colors.white
                            ],
                            contentColor: const Color(0xFF3B251D),
                          ),
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: _notifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications,
                                  size: 70, color: const Color(0x66DA9C5F)),
                              const Text("No tienes notificaciones",
                                  style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 84),
                          itemCount: _notifications.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final item = _notifications[index];

                            List<Color> bg = [
                              const Color(0xFF3498DB),
                              const Color(0xFF2980B9)
                            ];
                            IconData icon = Icons.notifications;
                            if (item.type == "success") {
                              bg = [
                                const Color(0xFF27AE60),
                                const Color(0xFF229954)
                              ];
                              icon = Icons.payments;
                            }
                            if (item.type == "warning") {
                              bg = [
                                const Color(0xFFF39C12),
                                const Color(0xFFE67E22)
                              ];
                              icon = Icons.warning;
                            }
                            if (item.type == "info") {
                              bg = [
                                const Color(0xFF9B59B6),
                                const Color(0xFF8E44AD)
                              ];
                              icon = Icons.apartment;
                            }

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  item.read = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: item.read
                                      ? Colors.white
                                      : const Color(0xFFFFFAF3),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2))
                                  ],
                                ),
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: bg),
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Icon(icon, color: Colors.white),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2C3E50))),
                                          Text(item.body,
                                              style: const TextStyle(
                                                  color: Color(0xFF4B5563),
                                                  fontSize: 13)),
                                          Row(
                                            children: [
                                              const Icon(Icons.schedule,
                                                  color: Color(0xFF9CA3AF),
                                                  size: 12),
                                              const SizedBox(width: 4),
                                              Text(item.time,
                                                  style: const TextStyle(
                                                      color: Color(0xFF9CA3AF),
                                                      fontSize: 11)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const Icon(Icons.chevron_right,
                                            color: Color(0xFFB8791F)),
                                        if (!item.read)
                                          Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                  color: Color(0xFFDA9C5F),
                                                  shape: BoxShape.circle))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
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
    );
  }
}

class _NotificationsBackground extends StatefulWidget {
  const _NotificationsBackground();
  @override
  State<_NotificationsBackground> createState() =>
      _NotificationsBackgroundState();
}

class _NotificationsBackgroundState extends State<_NotificationsBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
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
          children: List.generate(8, (i) {
            return Positioned(
              left: (i * 42.0),
              top: 50.0 + (i * 60.0) + (_ctrl.value * -20.0),
              child: Container(
                width: 4.0,
                height: 4.0,
                decoration: const BoxDecoration(
                    color: Color(0x66DA9C5F), shape: BoxShape.circle),
              ),
            );
          }),
        );
      },
    );
  }
}
