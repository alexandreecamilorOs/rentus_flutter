import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/animated_heading.dart';
import 'package:go_router/go_router.dart';
import '../../components/modern_view_wrapper.dart';

class ContractItem {
  final int id;
  final String title;
  final String address;
  final String status;
  final String price;

  ContractItem(this.id, this.title, this.address, this.status, this.price);
}

class ContractsScreen extends StatefulWidget {
  const ContractsScreen({super.key});

  @override
  State<ContractsScreen> createState() => _ContractsScreenState();
}

class _ContractsScreenState extends State<ContractsScreen> {
  final List<ContractItem> _contracts = [
    ContractItem(212, "Contrato Torre Alta", "Bogotá - Chapinero", "Activo",
        "\$2.500.000"),
    ContractItem(213, "Contrato Vista Sol", "Medellín - Laureles", "Pendiente",
        "\$3.100.000"),
    ContractItem(214, "Contrato Gran Reserva", "Cali - El Peñón", "Activo",
        "\$1.900.000"),
  ];
  int _active = 0;
  int _showPreview = -1;

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
            child: ListView(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 18, bottom: 84),
              children: [
                const AnimatedHeading(
                    text: "Contratos",
                    style: TextStyle(fontSize: 30),
                    gradientColors: [
                      Color(0xFFFFF2E0),
                      Color(0xFFF6D2A5),
                      Color(0xFFDA9C5F)
                    ],
                    durationMillis: 2800),
                const SizedBox(height: 4),
                const Text(
                    "Gestiona y revisa tus contratos con animaciones y acciones rápidas.",
                    style: TextStyle(color: Color(0xFFD4C5B9), fontSize: 13)),
                const SizedBox(height: 14),
                ..._contracts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final contract = entry.value;
                  final isActive = _active == index;

                  return GestureDetector(
                    onTap: () => setState(() => _active = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 14),
                      transform: Matrix4.identity()
                        ..scale(isActive ? 1.0 : 0.95),
                      transformAlignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xF23A2318),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: isActive
                            ? [
                                const BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 10,
                                    offset: Offset(0, 4))
                              ]
                            : [
                                const BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2))
                              ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade900,
                                  borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.image,
                                  size: 48, color: Colors.white24),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(contract.title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                Text(contract.status,
                                    style: TextStyle(
                                        color: contract.status == "Activo"
                                            ? const Color(0xFF2ECC71)
                                            : const Color(0xFFF39C12),
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Text(contract.address,
                                style: const TextStyle(
                                    color: Color(0xFFD4C5B9), fontSize: 12)),
                            Text("${contract.price} / mes",
                                style: const TextStyle(
                                    color: Color(0xFFDA9C5F),
                                    fontWeight: FontWeight.w900)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: AppActionButton(
                                    text: "Vista previa",
                                    onClick: () =>
                                        setState(() => _showPreview = index),
                                    gradient: const [
                                      Color(0xFFDA9C5F),
                                      Color(0xFFB8791F),
                                      Color(0xFFDA9C5F)
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Color(0xFF3498DB),
                                        Color(0xFF2980B9)
                                      ]),
                                      borderRadius: BorderRadius.circular(14)),
                                  child: IconButton(
                                      icon: const Icon(Icons.download,
                                          color: Colors.white),
                                      onPressed: () {}),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_active > 0) setState(() => _active--);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            color: const Color(0xAA562C1D),
                            borderRadius: BorderRadius.circular(22)),
                        child:
                            const Icon(Icons.chevron_left, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text("${_active + 1} / ${_contracts.length}",
                        style: const TextStyle(
                            color: Color(0xFFF0E5DB),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        if (_active < _contracts.length - 1)
                          setState(() => _active++);
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                            color: const Color(0xAA562C1D),
                            borderRadius: BorderRadius.circular(22)),
                        child: const Icon(Icons.chevron_right,
                            color: Colors.white),
                      ),
                    ),
                  ],
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
          if (_showPreview >= 0)
            Container(
              color: Colors.black54,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF2E1D17),
                          borderRadius: BorderRadius.circular(18)),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.description,
                                  color: Color(0xFFDA9C5F)),
                              const SizedBox(width: 8),
                              Text(_contracts[_showPreview].title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text("Dirección: ${_contracts[_showPreview].address}",
                              style: const TextStyle(
                                  color: Color(0xFFD4C5B9), fontSize: 13)),
                          Text("Estado: ${_contracts[_showPreview].status}",
                              style: const TextStyle(
                                  color: Color(0xFFD4C5B9), fontSize: 13)),
                          Text("Valor: ${_contracts[_showPreview].price}",
                              style: const TextStyle(
                                  color: Color(0xFFDA9C5F),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 14),
                          AppActionButton(
                            text: "Cerrar",
                            onClick: () => setState(() => _showPreview = -1),
                            gradient: const [
                              Color(0xFFE74C3C),
                              Color(0xFFC0392B),
                              Color(0xFFE74C3C)
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
