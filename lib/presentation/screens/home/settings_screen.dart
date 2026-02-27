import 'package:flutter/material.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import 'package:go_router/go_router.dart';
import '../../components/modern_view_wrapper.dart';

enum SettingsSection { Profile, Security, Notifications, Preferences }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsSection _activeSection = SettingsSection.Profile;

  String fullName = "Juan Esteban López";
  String email = "juan.lopez@rentus.co";
  String phone = "+57 300 123 4567";
  String document = "CC 1020xxxxxx";
  String bio = "Inversionista inmobiliario y anfitrión de propiedades premium.";
  String department = "Cundinamarca";
  String city = "Bogotá";

  String currentPassword = "";
  String newPassword = "";
  String confirmPassword = "";

  List<Map<String, dynamic>> notifications = [
    {
      "title": "Nuevas solicitudes",
      "description": "Avisarme cuando llegue una solicitud nueva",
      "enabled": true
    },
    {
      "title": "Recordatorios de pago",
      "description": "Avisarme 48h antes de vencimientos",
      "enabled": true
    },
    {
      "title": "Mensajes",
      "description": "Notificar nuevos mensajes del chat",
      "enabled": true
    },
    {
      "title": "Resumen semanal",
      "description": "Enviar reporte semanal por email",
      "enabled": false
    },
  ];

  String language = "Español";
  String timezone = "America/Bogota";
  String units = "Métrico";

  int get passwordScore {
    int score = 0;
    if (newPassword.length >= 8) score++;
    if (newPassword.contains(RegExp(r'[A-Z]')) &&
        newPassword.contains(RegExp(r'[a-z]'))) score++;
    if (newPassword.contains(RegExp(r'[0-9]'))) score++;
    if (newPassword.contains(RegExp(r'[^a-zA-Z0-9]'))) score++;
    if (newPassword == confirmPassword && confirmPassword.isNotEmpty) score++;
    return score;
  }

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
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 14, bottom: 84),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SETTINGS",
                      style: TextStyle(
                          color: Color(0xFFDA9C5F),
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                  const Text("Configuración",
                      style: TextStyle(
                          color: Color(0xFFFFF4E8),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          height: 1.1)),
                  const SizedBox(height: 4),
                  const Text("Administra tu perfil, seguridad y preferencias.",
                      style: TextStyle(color: Color(0xFFD4C5B9), fontSize: 12)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Sidebar(
                          active: _activeSection,
                          onSelect: (sec) =>
                              setState(() => _activeSection = sec),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xE62E1D17),
                                borderRadius: BorderRadius.circular(16)),
                            child: ListView(
                              padding: const EdgeInsets.all(12),
                              children: [
                                _buildContent(),
                                const SizedBox(height: 8),
                                AppActionButton(
                                  text: "Cerrar sesión",
                                  onClick: () => context.go('/login'),
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
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: HomeNavbar(
              selectedTab: "Settings",
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

  Widget _buildContent() {
    switch (_activeSection) {
      case SettingsSection.Profile:
        return Column(
          children: [
            const _SectionTitle(Icons.person, "Perfil"),
            _SettingsInput("Nombre completo", fullName,
                (v) => setState(() => fullName = v)),
            _SettingsInput("Email", email, (v) => setState(() => email = v),
                enabled: false),
            _SettingsInput("Teléfono", phone, (v) => setState(() => phone = v)),
            _SettingsInput(
                "Documento", document, (v) => setState(() => document = v)),
            _SettingsInput("Bio", bio, (v) => setState(() => bio = v)),
            _SettingsInput("Departamento", department,
                (v) => setState(() => department = v)),
            _SettingsInput("Ciudad", city, (v) => setState(() => city = v)),
            const SizedBox(height: 10),
            _ActionsRow("Guardar cambios", () {}, () {}),
          ],
        );
      case SettingsSection.Security:
        Color strengthColor = const Color(0xFFE74C3C);
        String strengthText = "Muy débil";
        if (passwordScore > 1) {
          strengthText = "Media";
          strengthColor = const Color(0xFFF39C12);
        }
        if (passwordScore > 3) {
          strengthText = "Fuerte";
          strengthColor = const Color(0xFF2ECC71);
        }

        return Column(
          children: [
            const _SectionTitle(Icons.lock, "Seguridad"),
            _SettingsInput("Contraseña actual", currentPassword,
                (v) => setState(() => currentPassword = v),
                obscure: true),
            _SettingsInput("Nueva contraseña", newPassword,
                (v) => setState(() => newPassword = v),
                obscure: true),
            _SettingsInput("Confirmar contraseña", confirmPassword,
                (v) => setState(() => confirmPassword = v),
                obscure: true),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                          color: strengthColor.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(999)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(strengthText,
                      style: TextStyle(
                          color: strengthColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _ActionsRow("Actualizar contraseña", () {}, () {
              setState(() {
                currentPassword = "";
                newPassword = "";
                confirmPassword = "";
              });
            }),
          ],
        );
      case SettingsSection.Notifications:
        return Column(
          children: [
            const _SectionTitle(Icons.notifications, "Notificaciones"),
            ...notifications.asMap().entries.map((entry) {
              int idx = entry.key;
              var item = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                    color: const Color(0x1AFFFFFF),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['title'],
                              style: const TextStyle(
                                  color: Color(0xFFF0E5DB),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13)),
                          Text(item['description'],
                              style: const TextStyle(
                                  color: Color(0xFFBFAFA2), fontSize: 11)),
                        ],
                      ),
                    ),
                    Switch(
                      value: item['enabled'],
                      onChanged: (val) =>
                          setState(() => notifications[idx]['enabled'] = val),
                      activeColor: const Color(0xFFDA9C5F),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 10),
            _ActionsRow("Guardar preferencias", () {}, () {}),
          ],
        );
      case SettingsSection.Preferences:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(Icons.tune, "Preferencias"),
            _SettingsInputWithIcon("Idioma", language, Icons.language,
                (v) => setState(() => language = v)),
            _SettingsInputWithIcon("Zona horaria", timezone, Icons.public,
                (v) => setState(() => timezone = v)),
            _SettingsInputWithIcon("Sistema de unidades", units,
                Icons.straighten, (v) => setState(() => units = v)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "* Se removió el selector oscuro/claro como solicitaste.",
                style: TextStyle(
                    color: Color(0xFFC8A97E),
                    fontSize: 11,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 10),
            _ActionsRow("Guardar", () {}, () {}),
          ],
        );
    }
  }
}

class _Sidebar extends StatelessWidget {
  final SettingsSection active;
  final ValueChanged<SettingsSection> onSelect;

  const _Sidebar({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
          color: const Color(0xE63B251D),
          borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _SidebarItem(
              label: "Perfil",
              icon: Icons.person,
              section: SettingsSection.Profile,
              active: active,
              onSelect: onSelect),
          _SidebarItem(
              label: "Seguridad",
              icon: Icons.lock,
              section: SettingsSection.Security,
              active: active,
              onSelect: onSelect),
          _SidebarItem(
              label: "Avisos",
              icon: Icons.notifications,
              section: SettingsSection.Notifications,
              active: active,
              onSelect: onSelect),
          _SidebarItem(
              label: "Preferencias",
              icon: Icons.tune,
              section: SettingsSection.Preferences,
              active: active,
              onSelect: onSelect),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final SettingsSection section;
  final SettingsSection active;
  final ValueChanged<SettingsSection> onSelect;

  const _SidebarItem(
      {required this.label,
      required this.icon,
      required this.section,
      required this.active,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    bool selected = section == active;
    return GestureDetector(
      onTap: () => onSelect(section),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0x66DA9C5F) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected
                    ? const Color(0xFFFFE7C7)
                    : const Color(0xFFD4C5B9),
                size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: selected
                        ? const Color(0xFFFFE7C7)
                        : const Color(0xFFD4C5B9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFDA9C5F), size: 18),
          const SizedBox(width: 6),
          Text(title,
              style: const TextStyle(
                  color: Color(0xFFFFE7C7),
                  fontSize: 17,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SettingsInput extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChange;
  final bool enabled;
  final bool obscure;

  const _SettingsInput(this.label, this.value, this.onChange,
      {this.enabled = true, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFFD4C5B9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            onChanged: onChange,
            enabled: enabled,
            obscureText: obscure,
            style: TextStyle(color: enabled ? Colors.white : Colors.grey),
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          )
        ],
      ),
    );
  }
}

class _SettingsInputWithIcon extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ValueChanged<String> onChange;

  const _SettingsInputWithIcon(
      this.label, this.value, this.icon, this.onChange);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Color(0xFFD4C5B9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          TextFormField(
            initialValue: value,
            onChanged: onChange,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            ),
          )
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final String primaryText;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const _ActionsRow(this.primaryText, this.onPrimary, this.onSecondary);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppActionButton(
            text: "Cancelar",
            onClick: onSecondary,
            gradient: const [
              Color(0xFF64748B),
              Color(0xFF475569),
              Color(0xFF64748B)
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppActionButton(
            text: primaryText,
            onClick: onPrimary,
            gradient: const [
              Color(0xFFDA9C5F),
              Color(0xFFB8791F),
              Color(0xFFDA9C5F)
            ],
          ),
        ),
      ],
    );
  }
}
