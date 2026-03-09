import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../data/models/notification_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';
import '../../components/home_navbar.dart';
import '../../components/modern_view_wrapper.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0A0F),
      body: Stack(
        children: [
          const _CinematicBackground(),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 14, bottom: 84),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, ref, notificationsAsync),
                  const SizedBox(height: 16),
                  Expanded(
                    child: notificationsAsync.when(
                      data: (items) =>
                          _buildNotificationsList(context, ref, items),
                      loading: () => const Center(
                        child:
                            CircularProgressIndicator(color: Color(0xFFDA9C5F)),
                      ),
                      error: (e, _) => Center(
                        child: Text('Error: $e',
                            style: const TextStyle(color: Colors.redAccent)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Navbar
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Notificaciones",
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

  Widget _buildHeader(BuildContext context, WidgetRef ref,
      AsyncValue<List<NotificationModel>> notificationsAsync) {
    int unreadCount = 0;
    if (notificationsAsync is AsyncData<List<NotificationModel>>) {
      unreadCount = notificationsAsync.value.where((n) => !n.isRead).length;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_active,
                    color: Color(0xFFDA9C5F), size: 28),
                if (unreadCount > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: Color(0xFFE74C3C), shape: BoxShape.circle),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("AVISOS",
                    style: TextStyle(
                        color: Color(0xFF9B59B6),
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5)),
                Text("Notificaciones",
                    style: TextStyle(
                        color: Color(0xFFF0E5DB),
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5)),
              ],
            ),
          ],
        ),
        if (unreadCount > 0)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await ref.read(notificationRepositoryProvider).markAllAsRead();
                ref.invalidate(notificationListProvider);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B59B6).withOpacity(0.1),
                  border: Border.all(
                      color: const Color(0xFF9B59B6).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.done_all, color: Color(0xFF9B59B6), size: 16),
                    SizedBox(width: 6),
                    Text("Marcar todo",
                        style: TextStyle(
                            color: Color(0xFF9B59B6),
                            fontSize: 12,
                            fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationsList(
      BuildContext context, WidgetRef ref, List<NotificationModel> items) {
    if (items.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF9B59B6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_rounded,
                color: Color(0xFF9B59B6), size: 64),
          ),
          const SizedBox(height: 24),
          const Text("Todo al día por aquí",
              style: TextStyle(
                  color: Color(0xFFF0E5DB),
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text("Te avisaremos cuando haya novedades importantes.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color(0xFFF0E5DB).withOpacity(0.5),
                  fontSize: 14)),
        ],
      );
    }

    final grouped = _groupByDate(items);

    return ListView.builder(
      itemCount: grouped.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final dateKey = grouped.keys.elementAt(index);
        final dateItems = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          height: 1,
                          color: const Color(0xFFDA9C5F).withOpacity(0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      dateKey,
                      style: const TextStyle(
                          color: Color(0xFFD4C5B9),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                      child: Container(
                          height: 1,
                          color: const Color(0xFFDA9C5F).withOpacity(0.2))),
                ],
              ),
            ),
            ...dateItems
                .map((item) => _buildNotificationCard(context, ref, item)),
          ],
        );
      },
    );
  }

  Map<String, List<NotificationModel>> _groupByDate(
      List<NotificationModel> items) {
    final Map<String, List<NotificationModel>> groups = {};
    for (var item in items) {
      final label = _getDateLabel(item.createdAt);
      if (!groups.containsKey(label)) {
        groups[label] = [];
      }
      groups[label]!.add(item);
    }
    return groups;
  }

  String _getDateLabel(DateTime? date) {
    if (date == null) return "Hoy";
    final now = DateTime.now();
    final localDate = date.toLocal();

    if (localDate.year == now.year &&
        localDate.month == now.month &&
        localDate.day == now.day) {
      return "Hoy";
    }

    final yesterday = now.subtract(const Duration(days: 1));
    if (localDate.year == yesterday.year &&
        localDate.month == yesterday.month &&
        localDate.day == yesterday.day) {
      return "Ayer";
    }

    return DateFormat("d 'de' MMMM", "es").format(localDate);
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'rental_request':
        return const Color(0xFF3498DB);
      case 'counter_proposal':
        return const Color(0xFFF39C12);
      case 'contract_sent':
      case 'contract_accepted':
        return const Color(0xFF2ECC71);
      case 'visit_reminder':
        return const Color(0xFFDA9C5F);
      case 'payment_reminder':
        return const Color(0xFFF39C12);
      case 'system':
        return const Color(0xFF9B59B6);
      default:
        return const Color(0xFFDA9C5F);
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'rental_request':
        return Icons.home_work;
      case 'counter_proposal':
        return Icons.edit_calendar;
      case 'contract_sent':
        return Icons.description;
      case 'contract_accepted':
        return Icons.check_circle;
      case 'visit_reminder':
        return Icons.access_time;
      case 'payment_reminder':
        return Icons.attach_money;
      case 'system':
        return Icons.admin_panel_settings;
      default:
        return Icons.notifications;
    }
  }

  String _stripHtml(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  Widget _buildNotificationCard(
      BuildContext context, WidgetRef ref, NotificationModel item) {
    final color = _getNotificationColor(item.type);
    final icon = _getNotificationIcon(item.type);
    final textContent = _stripHtml(item.body);
    final isUnread = !item.isRead;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread ? color.withOpacity(0.08) : const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUnread ? color.withOpacity(0.3) : const Color(0x1AFFFFFF),
        ),
        boxShadow: isUnread
            ? [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (!item.isRead) {
              await ref
                  .read(notificationRepositoryProvider)
                  .markAsRead(item.id);
              ref.invalidate(notificationListProvider);
            }
            _handleRouting(context, item);
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          color: isUnread
                              ? const Color(0xFFF0E5DB)
                              : const Color(0xFFF0E5DB).withOpacity(0.7),
                          fontWeight:
                              isUnread ? FontWeight.w900 : FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        textContent,
                        style: TextStyle(
                          color: const Color(0xFFF0E5DB).withOpacity(0.5),
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              color: const Color(0xFFF0E5DB).withOpacity(0.3),
                              size: 12),
                          const SizedBox(width: 4),
                          Text(
                            item.createdAt != null
                                ? DateFormat('hh:mm a')
                                    .format(item.createdAt!.toLocal())
                                : '',
                            style: TextStyle(
                              color: const Color(0xFFF0E5DB).withOpacity(0.3),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Actions
                Column(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await ref
                            .read(notificationRepositoryProvider)
                            .deleteNotification(item.id);
                        ref.invalidate(notificationListProvider);
                      },
                      icon: Icon(Icons.close_rounded,
                          color: const Color(0xFFF0E5DB).withOpacity(0.3),
                          size: 18),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                    if (isUnread) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.5),
                              blurRadius: 8,
                            )
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRouting(BuildContext context, NotificationModel notif) {
    if (notif.data.isEmpty) return;

    switch (notif.type) {
      case 'rental_request':
        context.go('/owner_requests');
        break;
      case 'counter_proposal':
        context.go('/my_requests');
        break;
      case 'contract_sent':
        context.go('/contracts');
        break;
      case 'visit_reminder':
        final propId = notif.data['property_id'];
        if (propId != null) context.push('/property/$propId');
        break;
      default:
        break;
    }
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
              colors: [Color(0xFF0D0A0F), Color(0xFF130D1A), Color(0xFF1A1221)],
            ),
          ),
        ),
        // Glow Orbs
        Positioned(
          top: -150,
          right: -100,
          child: _GlowOrb(
            color: const Color(0xFF9B59B6).withOpacity(0.1),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -100,
          left: -150,
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
