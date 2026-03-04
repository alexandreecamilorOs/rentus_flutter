import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/contract_model.dart';
import '../../../data/providers/entity_providers.dart';
import '../../../data/providers/repositories_providers.dart';
import '../../components/app_action_button.dart';

class ContractsScreen extends ConsumerStatefulWidget {
  const ContractsScreen({super.key});

  @override
  ConsumerState<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends ConsumerState<ContractsScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contractsAsync = ref.watch(myContractsProvider);

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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back,
                                color: Color(0xFFF0E5DB)),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "MIS DOCUMENTOS",
                                style: TextStyle(
                                  color:
                                      const Color(0xFFDA9C5F).withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0,
                                ),
                              ),
                              const Text(
                                "Contratos",
                                style: TextStyle(
                                  color: Color(0xFFF0E5DB),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Gestiona tus acuerdos de arrendamiento",
                        style: TextStyle(
                          color: const Color(0xFFF0E5DB).withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Carousel
                Expanded(
                  child: contractsAsync.when(
                    data: (contracts) {
                      if (contracts.isEmpty) {
                        return const _EmptyContracts(
                            key: ValueKey('empty_contracts'));
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) =>
                                  setState(() => _currentPage = index),
                              itemCount: contracts.length,
                              itemBuilder: (context, index) {
                                final contract = contracts[index];
                                return _ContractCarouselItem(
                                  key: ValueKey(contract.id),
                                  contract: contract,
                                  isActive: _currentPage == index,
                                  onReview: () =>
                                      _showReviewModal(context, contract),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          _CarouselIndicator(
                              count: contracts.length, current: _currentPage),
                          const SizedBox(height: 40),
                        ],
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

  void _showReviewModal(BuildContext context, Contract contract) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1412),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ContractReviewSheet(contract: contract),
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
          left: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA1155).withOpacity(0.05),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -100,
          right: -100,
          child: _GlowOrb(
            color: const Color(0xFFDA9C5F).withOpacity(0.1),
            size: 350,
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

class _ContractCarouselItem extends StatefulWidget {
  final Contract contract;
  final bool isActive;
  final VoidCallback onReview;

  const _ContractCarouselItem({
    super.key,
    required this.contract,
    required this.isActive,
    required this.onReview,
  });

  @override
  State<_ContractCarouselItem> createState() => _ContractCarouselItemState();
}

class _ContractCarouselItemState extends State<_ContractCarouselItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.contract.status.toLowerCase() == 'pending') {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);
    final isPending = widget.contract.status.toLowerCase() == 'pending';

    return AnimatedScale(
      scale: widget.isActive ? 1.0 : 0.9,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1410),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: isPending
                    ? const Color(0xFFDA9C5F)
                        .withOpacity(0.3 + (0.4 * _pulseController.value))
                    : const Color(0xFFDA9C5F).withOpacity(0.15),
                width: isPending ? 2.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isPending
                      ? const Color(0xFFDA9C5F)
                          .withOpacity(0.1 * _pulseController.value)
                      : Colors.black.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: isPending ? 5 * _pulseController.value : 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Column(
                children: [
                  // Image & Header
                  Expanded(
                    flex: 4,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration:
                              const BoxDecoration(color: Color(0xFF2D1D18)),
                          child: widget.contract.property?.propertyImages
                                      .isNotEmpty ==
                                  true
                              ? Image.network(
                                  widget.contract.property!.propertyImages.first
                                      .url,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                      Icons.home_work_rounded,
                                      color: Color(0xFFDA9C5F),
                                      size: 60),
                                )
                              : const Icon(Icons.home_work_rounded,
                                  color: Color(0xFFDA9C5F), size: 60),
                        ),
                        // Overlay Gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20,
                          right: 20,
                          child: _StatusBadge(status: widget.contract.status),
                        ),
                      ],
                    ),
                  ),
                  // Info & Actions
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contract.property?.title ??
                                "Contrato Rentus",
                            style: const TextStyle(
                              color: Color(0xFFF0E5DB),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  size: 14, color: Color(0xFFDA9C5F)),
                              const SizedBox(width: 8),
                              Text(
                                "Desde ${widget.contract.startDate ?? "TBD"}",
                                style: TextStyle(
                                    color: const Color(0xFFF0E5DB)
                                        .withOpacity(0.5),
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Divider(color: Color(0x1AFFFFFF)),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _DetailInfo(
                                label: "MENSUALIDAD",
                                value: currencyFormat
                                    .format(widget.contract.monthlyPrice ?? 0),
                              ),
                              _DetailInfo(
                                label: "DURACIÓN",
                                value: "12 meses",
                                alignRight: true,
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (isPending)
                            AppActionButton(
                              text: "REVISAR Y FIRMAR",
                              onClick: widget.onReview,
                              gradient: const [
                                Color(0xFFDA9C5F),
                                Color(0xFFB8791F)
                              ],
                              contentColor: Colors.black,
                            )
                          else
                            AppActionButton(
                              text: "DESCARGAR PDF",
                              onClick: () {}, // Download logic
                              isSecondary: true,
                              contentColor: const Color(0xFFDA9C5F),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'active':
        color = const Color(0xFF2ECC71);
        break;
      case 'pending':
        color = const Color(0xFFDA9C5F);
        break;
      case 'expired':
        color = const Color(0xFFE74C3C);
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailInfo extends StatelessWidget {
  final String label;
  final String value;
  final bool alignRight;

  const _DetailInfo(
      {required this.label, required this.value, this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFDA9C5F).withOpacity(0.6),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFF0E5DB),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _CarouselIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _CarouselIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isSelected = current == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: isSelected ? 32 : 8,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFDA9C5F), Color(0xFFB8791F)])
                : null,
            color: isSelected ? null : const Color(0x33DA9C5F),
            borderRadius: BorderRadius.circular(100),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFDA9C5F).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _ContractReviewSheet extends ConsumerStatefulWidget {
  final Contract contract;

  const _ContractReviewSheet({required this.contract});

  @override
  ConsumerState<_ContractReviewSheet> createState() =>
      _ContractReviewSheetState();
}

class _ContractReviewSheetState extends ConsumerState<_ContractReviewSheet> {
  bool _accepted = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(24),
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0A09),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
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
                    "DOCUMENTO LEGAL",
                    style: TextStyle(
                        color: Color(0xFFDA9C5F),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0),
                  ),
                  Text(
                    "Revisión de Firma",
                    style: TextStyle(
                        color: Color(0xFFF0E5DB),
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5),
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
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(title: "Resumen del Acuerdo"),
                  const SizedBox(height: 16),
                  _SummaryRow(
                      label: "Propiedad",
                      value: widget.contract.property?.title ?? "N/A"),
                  _SummaryRow(
                      label: "Arrendador",
                      value: widget.contract.landlord?.name ?? "N/A"),
                  _SummaryRow(
                      label: "Valor Mensual",
                      value: currencyFormat
                          .format(widget.contract.monthlyPrice ?? 0),
                      isGold: true),
                  _SummaryRow(
                      label: "Depósito Inicial",
                      value:
                          currencyFormat.format(widget.contract.deposit ?? 0)),
                  _SummaryRow(
                      label: "Fecha Inicio",
                      value: widget.contract.startDate ?? "N/A"),
                  _SummaryRow(
                      label: "Fecha Fin",
                      value: widget.contract.endDate ?? "N/A"),
                  const SizedBox(height: 32),
                  _SectionTitle(title: "Cláusulas Especiales"),
                  const SizedBox(height: 16),
                  if (widget.contract.clauses.isEmpty)
                    const Text("No se definieron cláusulas adicionales.",
                        style: TextStyle(color: Colors.white24, fontSize: 13))
                  else
                    ...widget.contract.clauses.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.verified_user_rounded,
                                  color: Color(0xFFDA9C5F), size: 18),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Text(c,
                                      style: TextStyle(
                                          color: const Color(0xFFF0E5DB)
                                              .withOpacity(0.7),
                                          fontSize: 14,
                                          height: 1.5))),
                            ],
                          ),
                        )),
                  const SizedBox(height: 32),
                  _AgreementCheckbox(
                    value: _accepted,
                    onChanged: (v) => setState(() => _accepted = v ?? false),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          AppActionButton(
            text: _isLoading ? "FIRMANDO..." : "CONFIRMAR Y FIRMAR",
            onClick: _handleAccept,
            isEnabled: _accepted && !_isLoading,
            gradient: const [Color(0xFFDA9C5F), Color(0xFFB8791F)],
            contentColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Future<void> _handleAccept() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(contractRepositoryProvider)
          .acceptContract(widget.contract.id);
      if (mounted) {
        context.pop();
        ref.invalidate(myContractsProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Contrato firmado exitosamente."),
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isGold;

  const _SummaryRow(
      {required this.label, required this.value, this.isGold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: const Color(0xFFF0E5DB).withOpacity(0.5),
                  fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: isGold ? const Color(0xFFDA9C5F) : const Color(0xFFF0E5DB),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFF0E5DB),
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 2,
          decoration: BoxDecoration(
            color: const Color(0xFFDA9C5F),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _AgreementCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: value ? const Color(0x1ADA9C5F) : const Color(0x0AFFFFFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: value ? const Color(0xFFDA9C5F) : const Color(0x1AFFFFFF),
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? const Color(0xFFDA9C5F) : Colors.transparent,
                border: Border.all(
                  color: value
                      ? const Color(0xFFDA9C5F)
                      : const Color(0xFFDA9C5F).withOpacity(0.5),
                ),
              ),
              child: value
                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                  : null,
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                "Acepto los términos y certifico mi identidad para la firma legal.",
                style: TextStyle(
                  color: Color(0xFFF0E5DB),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyContracts extends StatelessWidget {
  const _EmptyContracts({super.key});

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
            child: const Icon(Icons.description_rounded,
                size: 64, color: Color(0xFFDA9C5F)),
          ),
          const SizedBox(height: 24),
          const Text(
            "Sin contratos pendientes",
            style: TextStyle(
                color: Color(0xFFF0E5DB),
                fontSize: 20,
                fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            "Tus acuerdos aparecerán aquí una vez generados.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: const Color(0xFFF0E5DB).withOpacity(0.5), fontSize: 13),
          ),
        ],
      ),
    );
  }
}
