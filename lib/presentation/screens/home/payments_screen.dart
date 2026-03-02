import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';
import '../../components/modern_view_wrapper.dart';
import '../../../data/models/payment_model.dart';
import '../../../data/providers/entity_providers.dart';

class PaymentRowItem {
  final int id;
  final String amount;
  final String status;
  final String date;
  final String type;

  PaymentRowItem(this.id, this.amount, this.status, this.date, this.type);
}

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  String _query = "";
  final List<PaymentRowItem> _rows = [
    PaymentRowItem(5531, "\$2.500.000", "paid", "2026-01-10", "Arriendo"),
    PaymentRowItem(5532, "\$800.000", "pending", "2026-01-20", "Depósito"),
    PaymentRowItem(5533, "\$2.500.000", "failed", "2026-02-10", "Arriendo"),
  ];

  PaymentRowItem _fromPayment(Payment payment) => PaymentRowItem(
        payment.id,
        '\$${payment.amount.toStringAsFixed(0)}',
        payment.status,
        '-',
        payment.contractId == null ? 'Pago' : 'Contrato ${payment.contractId}',
      );

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(paymentsProvider);
    final rows = paymentsAsync.maybeWhen(
      data: (items) => items.map(_fromPayment).toList(),
      orElse: () => _rows,
    );
    final filtered = rows
        .where((r) =>
            r.id.toString().contains(_query) ||
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
          const _PaymentsAnimatedBg(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                if (paymentsAsync.isLoading) const LinearProgressIndicator(minHeight: 2),
                if (paymentsAsync.hasError) Padding(padding: const EdgeInsets.only(top: 6), child: Text('Error cargando pagos', style: TextStyle(color: Colors.redAccent, fontSize: 11))),
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
                            child: const Icon(Icons.payments,
                                color: Color(0xFFDA9C5F)),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedHeading(
                                  text: "Pagos",
                                  style: TextStyle(fontSize: 28),
                                  gradientColors: [
                                    Color(0xFFFFF4E8),
                                    Color(0xFFF6D2A5),
                                    Color(0xFFDA9C5F)
                                  ],
                                  durationMillis: 2800),
                              Text("Historial y estado de tus pagos",
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
                              text: "Pagar ahora",
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
                              text: "Métodos",
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
                          hintText: "Buscar por id o tipo",
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
                      final p = filtered[index];
                      Color c = const Color(0xFFE74C3C);
                      if (p.status == "paid") c = const Color(0xFF2ECC71);
                      if (p.status == "pending") c = const Color(0xFFF59E0B);

                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xF23A2318),
                            borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: const Color(0x22DA9C5F),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.credit_card,
                                  color: Color(0xFFDA9C5F)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Pago #${p.id}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Text("${p.date} · ${p.type}",
                                      style: const TextStyle(
                                          color: Color(0xFFD4C5B9),
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(p.amount,
                                    style: const TextStyle(
                                        color: Color(0xFFDA9C5F),
                                        fontWeight: FontWeight.w900)),
                                Text(p.status.toUpperCase(),
                                    style: TextStyle(
                                        color: c,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold)),
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
        ],
      ),
    ).modernWrapped();
  }
}

class _PaymentsAnimatedBg extends StatefulWidget {
  const _PaymentsAnimatedBg();
  @override
  State<_PaymentsAnimatedBg> createState() => _PaymentsAnimatedBgState();
}

class _PaymentsAnimatedBgState extends State<_PaymentsAnimatedBg>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
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
          children: List.generate(12, (i) {
            return Positioned(
              left: (i * 32.0),
              top: 50.0 + (i * 46.0) + (_ctrl.value * -16.0),
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
