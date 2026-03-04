import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/repositories_providers.dart';
import '../../components/home_navbar.dart';
import '../../components/app_action_button.dart';
import '../../components/modern_view_wrapper.dart';

enum SettingsSection { profile, security, notifications, preferences }

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
        Positioned(
          top: -100,
          right: -100,
          child: _GlowOrb(
              color: const Color(0xFFDA9C5F).withOpacity(0.08), size: 400),
        ),
        Positioned(
          bottom: -150,
          left: -100,
          child: _GlowOrb(
              color: const Color(0xFF9B59B6).withOpacity(0.05), size: 450),
        ),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  SettingsSection _activeSection = SettingsSection.profile;

  // Profile data
  String fullName = "";
  final String email = ""; // Immutable from UI, read from user
  String phone = "";
  String document = "";
  String bio = "";
  String department = "";
  String city = "";
  bool _isLoadingUser = true;
  bool _isSavingProfile = false;

  // Security data
  String currentPassword = "";
  String newPassword = "";
  String confirmPassword = "";
  bool _isSavingPassword = false;

  // Preferences (Local only like in Vue frontend)
  List<Map<String, dynamic>> notificationsList = [
    {
      "title": "Correos de novedades",
      "description": "Conocer nuevas ofertas",
      "enabled": true
    },
    {
      "title": "Alertas de propiedades",
      "description": "Visitas programadas",
      "enabled": true
    },
    {
      "title": "Recordatorios",
      "description": "Recordatorios de visitas",
      "enabled": false
    },
    {
      "title": "Promociones especiales",
      "description": "Descuentos",
      "enabled": true
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final user = ref.read(authProvider).user;
    if (user != null) {
      setState(() {
        fullName = user.name;
        phone = user.phone ?? "";
        document = user.idDocumento ?? "";
        bio = user.bio ?? "";
        department = user.department ?? "";
        city = user.city ?? "";
        _isLoadingUser = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    setState(() => _isSavingProfile = true);
    try {
      final updatedData = {
        'name': fullName,
        'phone': phone,
        'id_documento': document,
        'bio': bio,
        'department': department,
        'city': city,
      };

      await ref.read(userRepositoryProvider).updateUser(user.id, updatedData);

      // Refresh Auth User State
      await ref.read(authProvider.notifier).bootstrap();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Perfil actualizado correctamente.'),
            backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error al actualizar: $e'),
            backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSavingProfile = false);
    }
  }

  Future<void> _updatePassword() async {
    if (newPassword.isEmpty ||
        currentPassword.isEmpty ||
        newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Por favor completa las contraseñas correctamente.'),
          backgroundColor: Colors.red));
      return;
    }
    if (newPassword.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('La contraseña debe tener mínimo 8 caracteres.'),
          backgroundColor: Colors.red));
      return;
    }

    setState(() => _isSavingPassword = true);
    try {
      await ref.read(authRepositoryProvider).updatePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Contraseña actualizada correctamente.'),
            backgroundColor: Colors.green));
        setState(() {
          currentPassword = "";
          newPassword = "";
          confirmPassword = "";
        });
      }
    } catch (e) {
      String msg = "Error al actualizar la contraseña";
      if (e is DioException && e.response?.statusCode == 422) {
        msg = e.response?.data?['message'] ?? msg;
      } else if (e is DioException && e.response?.statusCode == 401) {
        msg = "Contraseña actual incorrecta";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSavingPassword = false);
    }
  }

  int get passwordScore {
    int score = 0;
    if (newPassword.length >= 8) score++;
    if (newPassword.contains(RegExp(r'[A-Z]')) &&
        newPassword.contains(RegExp(r'[a-z]'))) {
      score++;
    }
    if (newPassword.contains(RegExp(r'[0-9]'))) score++;
    if (newPassword.contains(RegExp(r'[^a-zA-Z0-9]'))) score++;
    if (newPassword == confirmPassword && confirmPassword.isNotEmpty) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0A0E),
      body: Stack(
        children: [
          const _CinematicBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),

                // Horizontal Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTab(SettingsSection.profile, Icons.person_rounded,
                            "Perfil"),
                        _buildTab(SettingsSection.security, Icons.lock_rounded,
                            "Seguridad"),
                        _buildTab(SettingsSection.notifications,
                            Icons.notifications_rounded, "Avisos"),
                        _buildTab(SettingsSection.preferences,
                            Icons.palette_rounded, "Tema"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Content Area
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _isLoadingUser
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFFDA9C5F)))
                        : ListView(
                            padding: const EdgeInsets.only(bottom: 100),
                            children: [
                              _buildActiveSection(),
                            ],
                          ),
                  ),
                ),
              ],
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "PREFERENCIAS",
                style: TextStyle(
                  color: const Color(0xFFDA9C5F).withOpacity(0.6),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                "Configuración",
                style: TextStyle(
                  color: Color(0xFFF0E5DB),
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () async => await ref.read(authProvider.notifier).logout(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
              ),
              child: const Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(SettingsSection section, IconData icon, String label) {
    final active = _activeSection == section;
    return GestureDetector(
      onTap: () => setState(() => _activeSection = section),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFDA9C5F).withOpacity(0.15)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: active
                  ? const Color(0xFFDA9C5F).withOpacity(0.5)
                  : Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Icon(icon,
                color:
                    active ? const Color(0xFFDA9C5F) : const Color(0xFFD4C5B9),
                size: 16),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color:
                    active ? const Color(0xFFDA9C5F) : const Color(0xFFD4C5B9),
                fontWeight: active ? FontWeight.w900 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSection() {
    switch (_activeSection) {
      case SettingsSection.profile:
        return _buildProfileForm();
      case SettingsSection.security:
        return _buildSecurityForm();
      case SettingsSection.notifications:
        return _buildNotificationsForm();
      case SettingsSection.preferences:
        return _buildPreferencesForm();
    }
  }

  Widget _buildProfileForm() {
    final user = ref.read(authProvider).user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Datos Personales"),
        _SettingsInput(
            "Nombre completo", fullName, (v) => setState(() => fullName = v)),
        _SettingsInput("Email", user?.email ?? "", (_) {}, enabled: false),
        _SettingsInput("Teléfono", phone, (v) => setState(() => phone = v)),
        _SettingsInput(
            "Documento", document, (v) => setState(() => document = v)),
        _SettingsInput(
            "Departamento", department, (v) => setState(() => department = v)),
        _SettingsInput("Ciudad", city, (v) => setState(() => city = v)),
        _SettingsInput("Biografía (Bio)", bio, (v) => setState(() => bio = v),
            maxLines: 3),
        const SizedBox(height: 24),
        AppActionButton(
          text: _isSavingProfile ? "GUARDANDO..." : "GUARDAR CAMBIOS",
          onClick: _isSavingProfile ? () {} : () => _saveProfile(),
          gradient: const [Color(0xFFDA9C5F), Color(0xFFB8791F)],
          contentColor: Colors.black,
        ),
      ],
    );
  }

  Widget _buildSecurityForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Seguridad"),
        _SettingsInput("Contraseña Actual", currentPassword,
            (v) => setState(() => currentPassword = v),
            obscureText: true),
        _SettingsInput("Nueva Contraseña", newPassword,
            (v) => setState(() => newPassword = v),
            obscureText: true),
        _SettingsInput("Confirmar Contraseña", confirmPassword,
            (v) => setState(() => confirmPassword = v),
            obscureText: true),
        const SizedBox(height: 12),
        _buildPasswordStrengthMeter(),
        const SizedBox(height: 32),
        AppActionButton(
          text: _isSavingPassword ? "ACTUALIZANDO..." : "ACTUALIZAR CONTRASEÑA",
          onClick: _isSavingPassword ? () {} : () => _updatePassword(),
          gradient: const [Color(0xFF2ECC71), Color(0xFF27AE60)],
          contentColor: Colors.black,
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthMeter() {
    if (newPassword.isEmpty) return const SizedBox.shrink();
    Color strengthColor = const Color(0xFFE74C3C);
    String strengthText = "Muy débil";
    if (passwordScore > 1) {
      strengthColor = const Color(0xFFE67E22);
      strengthText = "Débil";
    }
    if (passwordScore > 2) {
      strengthColor = const Color(0xFFF1C40F);
      strengthText = "Media";
    }
    if (passwordScore > 3) {
      strengthColor = const Color(0xFF2ECC71);
      strengthText = "Fuerte";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Fuerza:",
                style: TextStyle(color: Color(0xFFD4C5B9), fontSize: 13)),
            Text(strengthText,
                style: TextStyle(
                    color: strengthColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
              4,
              (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: index < passwordScore
                            ? strengthColor
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  Widget _buildNotificationsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Preferencias de Alertas"),
        ...notificationsList.map((notif) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notif['title'],
                            style: const TextStyle(
                                color: Color(0xFFF0E5DB),
                                fontSize: 15,
                                fontWeight: FontWeight.w900)),
                        Text(notif['description'],
                            style: TextStyle(
                                color: const Color(0xFFF0E5DB).withOpacity(0.4),
                                fontSize: 12)),
                      ],
                    ),
                  ),
                  Switch(
                    value: notif['enabled'],
                    activeColor: const Color(0xFFDA9C5F),
                    activeTrackColor: const Color(0xFFDA9C5F).withOpacity(0.3),
                    inactiveThumbColor: const Color(0xFFD4C5B9),
                    inactiveTrackColor: Colors.white10,
                    onChanged: (val) => setState(() => notif['enabled'] = val),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildPreferencesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Apariencia"),
        _preferenceRow("Tema", "Cinema Glow (Premium)"),
        _preferenceRow("Idioma", "Español (Latam)"),
        _preferenceRow("Divisa", "COP (Peso Colombiano)"),
      ],
    );
  }

  Widget _preferenceRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: const Color(0xFFF0E5DB).withOpacity(0.6),
                  fontSize: 14)),
          Text(value,
              style: const TextStyle(
                  color: Color(0xFFDA9C5F),
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 8),
      child: Text(title,
          style: const TextStyle(
              color: Color(0xFFF0E5DB),
              fontSize: 20,
              fontWeight: FontWeight.w900)),
    );
  }
}

class _SettingsInput extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final bool enabled;
  final bool obscureText;
  final int maxLines;

  const _SettingsInput(this.label, this.value, this.onChanged,
      {this.enabled = true, this.obscureText = false, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(
                  color: const Color(0xFFDA9C5F).withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1)),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: value,
            obscureText: obscureText,
            maxLines: maxLines,
            enabled: enabled,
            style: TextStyle(
                color: enabled
                    ? const Color(0xFFF0E5DB)
                    : const Color(0xFFF0E5DB).withOpacity(0.3),
                fontSize: 15,
                fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  enabled ? Colors.white.withOpacity(0.03) : Colors.transparent,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.05))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      BorderSide(color: Colors.white.withOpacity(0.05))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide:
                      const BorderSide(color: Color(0xFFDA9C5F), width: 1.5)),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
