import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import 'package:go_router/go_router.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0E0A),
      body: Stack(
        children: [
          // Background Gradient base
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
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
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                _buildHero(context),
                _buildStatsBar(),
                _buildStory(),
                _buildMissionVisionValues(),
                _buildDifferentiators(),
                _buildProcess(),
                _buildTeam(),
                _buildTestimonials(),
                _buildCTA(context),
              ],
            ),
          ),

          // HomeNavbar anclado al final
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Nosotros",
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

  Widget _buildSectionLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 1,
          color: const Color(0xFFC9915C),
          margin: const EdgeInsets.only(right: 10),
        ),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFC9915C),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel("Sobre Rentus"),
          const SizedBox(height: 16),
          const Text(
            "Una nueva forma\nde encontrar hogar.",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 38,
              color: Color(0xFFEDE8E1),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Nacimos en 2024 con una convicción: arrendar una propiedad debería ser claro, rápido y confiable. Sin letra pequeña, sin intermediarios innecesarios.",
            style: TextStyle(
              fontSize: 15,
              color: Color(0x8CEDE8E1), // ~55% opacidad
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: AppActionButton(
                  text: "Ver propiedades",
                  onClick: () => context.go('/properties'),
                  gradient: const [Color(0xFFC9915C), Color(0xFFDEA46E)],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // Scroll to story
                    _scrollController.animateTo(
                      400, // Aproximado para la historia
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0x26EDE8E1)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Text(
                    "Nuestra historia",
                    style: TextStyle(
                      color: Color(0xFFEDE8E1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final stats = [
      {"display": "10k+", "label": "Usuarios"},
      {"display": "5k+", "label": "Propiedades"},
      {"display": "4.8", "label": "Calificación"},
      {"display": "24/7", "label": "Soporte"},
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Color(0x05FFFFFF),
        border: Border(
          top: BorderSide(color: Color(0x0CEDE8E1)),
          bottom: BorderSide(color: Color(0x0CEDE8E1)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((s) {
          return Column(
            children: [
              Text(
                s["display"]!,
                style: const TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 28,
                  color: Color(0xFFC9915C),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s["label"]!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0x66EDE8E1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStory() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel("Nuestra historia"),
          const SizedBox(height: 16),
          const Text(
            "Empezamos\ncon un problema real.",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 32,
              color: Color(0xFFEDE8E1),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Encontrar arriendo en Colombia es complicado, opaco y lleno de fricción. Vimos eso de cerca y decidimos construir la plataforma que nos hubiera gustado tener: una donde propietarios e inquilinos se encuentren de forma directa y segura.\n\nSomos un equipo pequeño pero comprometido. No prometemos ser los más grandes — prometemos ser los más honestos.",
            style: TextStyle(
              fontSize: 15,
              color: Color(0x8CEDE8E1),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionValues() {
    final mvv = [
      {
        "icon": Icons.verified_user_outlined,
        "title": "Transparencia",
        "text": "Cero letras pequeñas ni cobros ocultos."
      },
      {
        "icon": Icons.bolt_outlined,
        "title": "Eficiencia",
        "text": "Aprobaciones y contratos en menos de 24h."
      },
      {
        "icon": Icons.handshake_outlined,
        "title": "Confianza",
        "text": "Soporte real por y para colombianos."
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: mvv.map((card) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0x06FFFFFF),
              border: Border.all(color: const Color(0x11EDE8E1)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(card["icon"] as IconData,
                    color: const Color(0xFFC9915C), size: 36),
                const SizedBox(height: 16),
                Text(
                  card["title"] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFFEDE8E1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  card["text"] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0x85EDE8E1),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDifferentiators() {
    final diffs = [
      {
        "num": "01",
        "icon": "⚡",
        "title": "Rápido",
        "desc": "Sin los papeleos interminables buscando fiador o codeudor."
      },
      {
        "num": "02",
        "icon": "🛡️",
        "title": "Seguro",
        "desc": "Garantizamos los pagos a propietarios y resolvemos daños."
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel("¿Por qué Rentus?"),
          const SizedBox(height: 16),
          const Text(
            "Menos fricción.\nMás confianza.",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 32,
              color: Color(0xFFEDE8E1),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: diffs.map((d) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      right: d == diffs.first ? 12 : 0,
                      left: d == diffs.last ? 12 : 0),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0x06FFFFFF),
                    border: Border.all(color: const Color(0x11EDE8E1)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(d["icon"]!,
                              style: const TextStyle(fontSize: 24)),
                          Text(d["num"]!,
                              style: const TextStyle(
                                  color: Color(0x1AEDE8E1),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        d["title"]!,
                        style: const TextStyle(
                            color: Color(0xFFEDE8E1),
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        d["desc"]!,
                        style: const TextStyle(
                            color: Color(0x80EDE8E1),
                            fontSize: 13,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProcess() {
    // Para simplificar la vista en móvil (ya que en Vue es un grid horizontal)
    // lo adaptaremos a un stepper vertical customizado.
    final steps = [
      {
        "icon": Icons.search,
        "title": "Encuentras",
        "desc": "Filtramos las propiedades ideales para ti en segundos."
      },
      {
        "icon": Icons.edit_document,
        "title": "Aplicas",
        "desc": "Llenas la documentación sin salir de la app de forma segura."
      },
      {
        "icon": Icons.home,
        "title": "Te mudas",
        "desc": "Recibimos la firma y coordinamos el inventario de la entrega."
      },
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel("Cómo funciona"),
          const SizedBox(height: 16),
          const Text(
            "Del interés al contrato,\nsin vueltas.",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 32,
              color: Color(0xFFEDE8E1),
            ),
          ),
          const SizedBox(height: 32),
          Column(
            children: steps.asMap().entries.map((entry) {
              int idx = entry.key;
              var step = entry.value;
              bool isLast = idx == steps.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0x14C9915C),
                          border: Border.all(color: const Color(0x52C9915C)),
                        ),
                        child: Center(
                          child: Text(
                            "${idx + 1}",
                            style: const TextStyle(
                              color: Color(0xFFC9915C),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 50,
                          color: const Color(0x1AEDE8E1),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(step["icon"] as IconData,
                              color: const Color(0xFFEDE8E1)),
                          const SizedBox(height: 8),
                          Text(
                            step["title"] as String,
                            style: const TextStyle(
                              color: Color(0xFFEDE8E1),
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step["desc"] as String,
                            style: const TextStyle(
                              color: Color(0x7AEDE8E1),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTeam() {
    final team = [
      {"initials": "AL", "name": "Alexa L.", "role": "Desarrollador"},
      {"initials": "DF", "name": "Daniel F.", "role": "Operaciones"},
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel("El equipo"),
          const SizedBox(height: 16),
          const Text(
            "Personas Reales.\nUna misma visión.",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 32,
              color: Color(0xFFEDE8E1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Somos desarrolladores que decidieron resolver un problema real. Sin grandes inversores — solo trabajo, iteración y compromiso.",
            style:
                TextStyle(color: Color(0x80EDE8E1), fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 32),
          Row(
            children: team.map((m) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      right: m == team.first ? 12 : 0,
                      left: m == team.last ? 12 : 0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0x06FFFFFF),
                    border: Border.all(color: const Color(0x11EDE8E1)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0x17C9915C),
                          border: Border.all(color: const Color(0x38C9915C)),
                        ),
                        child: Center(
                          child: Text(
                            m["initials"]!,
                            style: const TextStyle(
                                color: Color(0xFFC9915C),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        m["name"]!,
                        style: const TextStyle(
                            color: Color(0xFFEDE8E1),
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m["role"]!,
                        style: const TextStyle(
                            color: Color(0x66EDE8E1), fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonials() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionLabel("Lo que dicen"),
          const SizedBox(height: 16),
          const Text(
            "Experiencias reales.",
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 32,
              color: Color(0xFFEDE8E1),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0x06FFFFFF),
              border: Border.all(color: const Color(0x11EDE8E1)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                      5,
                      (index) => const Icon(Icons.star,
                          color: Color(0xFFC9915C), size: 16)),
                ),
                const SizedBox(height: 16),
                const Text(
                  "\"Logré alquilar mi apartamento en 2 días sin pagar seguros abusivos de la inmobiliaria. La app es súper intuitiva.\"",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xADEDE8E1),
                    height: 1.6,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0x17C9915C),
                        border: Border.all(color: const Color(0x33C9915C)),
                      ),
                      child: const Center(
                        child: Text("MR",
                            style: TextStyle(
                                color: Color(0xFFC9915C),
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("María Ruiz",
                            style: TextStyle(
                                color: Color(0xFFEDE8E1),
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        Text("Arrendadora",
                            style: TextStyle(
                                color: Color(0x61EDE8E1), fontSize: 12)),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        decoration: BoxDecoration(
          color: const Color(0x06FFFFFF),
          border: Border.all(color: const Color(0x11EDE8E1)),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            _buildSectionLabel("¿Listo?"),
            const SizedBox(height: 16),
            const Text(
              "Encuentra tu próximo\nhogar hoy mismo.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 28,
                color: Color(0xFFEDE8E1),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Únete a Rentus. Sin costos ocultos, sin promesas vacías.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0x7AEDE8E1), fontSize: 15),
            ),
            const SizedBox(height: 32),
            AppActionButton(
              text: "Explorar propiedades",
              onClick: () => context.go('/properties'),
              gradient: const [Color(0xFFC9915C), Color(0xFFDEA46E)],
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0x26EDE8E1)),
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                "Contactar soporte",
                style: TextStyle(
                  color: Color(0xFFEDE8E1),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
