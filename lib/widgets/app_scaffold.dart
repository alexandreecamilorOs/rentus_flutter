import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.currentRoute,
    this.actions,
  });

  final String title;
  final Widget child;
  final String currentRoute;
  final List<Widget>? actions;

  static const bottomItems = [
    ('/home', Icons.home_rounded, 'Home'),
    ('/properties', Icons.apartment_rounded, 'Propiedades'),
    ('/about', Icons.info_rounded, 'Nosotros'),
    ('/profile', Icons.person_rounded, 'Perfil'),
  ];

  static const drawerItems = [
    ('/notifications', Icons.notifications_rounded, 'Notificaciones'),
    ('/contracts', Icons.description_rounded, 'Contratos'),
    ('/payments', Icons.payments_rounded, 'Pagos'),
    ('/maintenance', Icons.build_rounded, 'Mantenimiento'),
    ('/my-requests', Icons.assignment_ind_rounded, 'Mis solicitudes'),
    ('/requests', Icons.assignment_rounded, 'Solicitudes'),
    ('/my-reports', Icons.summarize_rounded, 'Mis reportes'),
    ('/settings', Icons.settings_rounded, 'Configuración'),
  ];

  @override
  Widget build(BuildContext context) {
    final index = bottomItems.indexWhere((item) => item.$1 == currentRoute);

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF0D1B2A)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Rentus',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            for (final item in drawerItems)
              ListTile(
                leading: Icon(item.$2),
                title: Text(item.$3),
                selected: currentRoute == item.$1,
                onTap: () {
                  Navigator.pop(context);
                  if (currentRoute != item.$1) {
                    Navigator.pushReplacementNamed(context, item.$1);
                  }
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              },
            ),
          ],
        ),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index < 0 ? 0 : index,
        items: [
          for (final item in bottomItems) BottomNavigationBarItem(icon: Icon(item.$2), label: item.$3),
        ],
        onTap: (i) {
          final route = bottomItems[i].$1;
          if (route != currentRoute) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }
}
