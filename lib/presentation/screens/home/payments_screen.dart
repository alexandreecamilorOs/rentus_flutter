import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/payment_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../components/app_action_button.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  ConsumerState<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  String _statusFilter = 'Todos';

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(paymentsProvider);
    final methodsAsync = ref.watch(paymentMethodsProvider);

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
                            icon: Icons.credit_card_rounded,
                            onTap: () =>
                                _showManageMethods(context, methodsAsync),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "GESTIÓN FINANCIERA",
                        style: TextStyle(
                          color: const Color(0xFFDA9C5F),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const Text(
                        "Mis Pagos",
                        style: TextStyle(
                          color: Color(0xFFF0E5DB),
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Historial de transacciones y estados",
                        style: TextStyle(
                          color: const Color(0xFFF0E5DB).withOpacity(0.4),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Filters
                _StatusFilters(
                  selected: _statusFilter,
                  onChanged: (val) => setState(() => _statusFilter = val),
                ),

                const SizedBox(height: 16),

                // List
                Expanded(
                  child: paymentsAsync.when(
                    data: (payments) {
                      final filtered = _statusFilter == 'Todos'
                          ? payments
                          : payments
                              .where((p) =>
                                  p.status.toLowerCase() ==
                                  _statusFilter.toLowerCase())
                              .toList();

                      if (filtered.isEmpty) {
                        return const _EmptyPayments(
                            key: ValueKey('empty_payments'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) =>
                            _PaymentCard(payment: filtered[index]),
                      );
                    },
                    loading: () => const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFDA9C5F)),
                    ),
                    error: (e, s) => Center(
                      child: Text("Error: $e",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showManageMethods(
      BuildContext context, AsyncValue<List<PaymentMethod>> methodsAsync) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1412),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ManageMethodsSheet(methodsAsync: methodsAsync),
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
          right: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.08),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -100,
          left: -150,
          child: _GlowOrb(
            color: const Color(0xFFB87D4A).withOpacity(0.05),
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

class _StatusFilters extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const _StatusFilters({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final filters = ['Todos', 'Pagado', 'Pendiente', 'Fallido'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: filters.map((f) {
          final isSelected = selected == f;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => onChanged(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFFDA9C5F), Color(0xFFB87D4A)],
                        )
                      : null,
                  color: isSelected ? null : const Color(0x1AFFFFFF),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0x1ADA9C5F),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFDA9C5F).withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          )
                        ]
                      : null,
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? Colors.black : const Color(0xFFF0E5DB),
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final Payment payment;

  const _PaymentCard({required this.payment});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    final isPaid = payment.status.toLowerCase() == 'completed' ||
        payment.status.toLowerCase() == 'paid';

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
            onTap: () {}, // Show transaction details
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: (isPaid ? Colors.green : const Color(0xFFDA9C5F))
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: (isPaid ? Colors.green : const Color(0xFFDA9C5F))
                            .withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      isPaid
                          ? Icons.check_circle_rounded
                          : Icons.schedule_rounded,
                      color: isPaid ? Colors.green : const Color(0xFFDA9C5F),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.type?.toUpperCase() ?? "ARRENDAMIENTO",
                          style: const TextStyle(
                            color: Color(0xFFDA9C5F),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          payment.contract != null
                              ? "Canon de Arrendamiento"
                              : "Transacción Directa",
                          style: const TextStyle(
                            color: Color(0xFFF0E5DB),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 12,
                                color:
                                    const Color(0xFFF0E5DB).withOpacity(0.4)),
                            const SizedBox(width: 4),
                            Text(
                              payment.createdAt ?? "Reciente",
                              style: TextStyle(
                                color: const Color(0xFFF0E5DB).withOpacity(0.4),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(payment.amount),
                        style: const TextStyle(
                          color: Color(0xFFF0E5DB),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _StatusPill(isPaid: isPaid),
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

class _StatusPill extends StatelessWidget {
  final bool isPaid;
  const _StatusPill({required this.isPaid});

  @override
  Widget build(BuildContext context) {
    final color = isPaid ? Colors.green : const Color(0xFFDA9C5F);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
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
            isPaid ? "EXITOSO" : "PENDIENTE",
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
}

class _ManageMethodsSheet extends StatelessWidget {
  final AsyncValue<List<PaymentMethod>> methodsAsync;

  const _ManageMethodsSheet({required this.methodsAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
                    "CONFIGURACIÓN",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0),
                  ),
                  Text(
                    "Métodos de Pago",
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
          const SizedBox(height: 24),
          methodsAsync.when(
            data: (methods) {
              if (methods.isEmpty) {
                return const _EmptyMethods(key: ValueKey('empty_methods'));
              }
              return Column(
                children: methods.map((m) => _MethodRow(method: m)).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(color: Color(0xFFDA9C5F)),
              ),
            ),
            error: (e, s) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text("Error: $e",
                    style: const TextStyle(color: Colors.redAccent)),
              ),
            ),
          ),
          const SizedBox(height: 32),
          AppActionButton(
            text: "AÑADIR NUEVA TARJETA",
            onClick: () => context.pop(),
            gradient: const [Color(0xFFDA9C5F), Color(0xFFB87D4A)],
            contentColor: Colors.black,
            icon: Icons.add_rounded,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  final PaymentMethod method;

  const _MethodRow({required this.method});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0x1ADA9C5F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.credit_card_rounded,
                color: Color(0xFFDA9C5F), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "TARJETA BANCARIA",
                  style: TextStyle(
                    color: const Color(0xFFF0E5DB).withOpacity(0.4),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "•••• •••• •••• ${method.lastFour ?? '****'}",
                  style: const TextStyle(
                    color: Color(0xFFF0E5DB),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
          if (method.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFDA9C5F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: const Color(0x33DA9C5F)),
              ),
              child: const Text(
                "PRINCIPAL",
                style: TextStyle(
                  color: Color(0xFFDA9C5F),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyPayments extends StatelessWidget {
  const _EmptyPayments({super.key});

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
            child: const Icon(Icons.receipt_long_rounded,
                size: 64, color: Color(0xFFDA9C5F)),
          ),
          const SizedBox(height: 24),
          const Text(
            "Sin transacciones",
            style: TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            "Tu historial de pagos aparecerá aquí.",
            style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _EmptyMethods extends StatelessWidget {
  const _EmptyMethods({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x0AFFFFFF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: const Color(0x1AFFFFFF), style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(Icons.credit_card_off_rounded,
              size: 40, color: Color(0x33DA9C5F)),
          const SizedBox(height: 16),
          Text(
            "No tienes tarjetas guardadas",
            style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.4), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
