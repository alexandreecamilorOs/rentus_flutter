import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/section_card.dart';

class SimpleScreen extends StatelessWidget {
  const SimpleScreen({super.key, required this.route, required this.title, required this.items});

  final String route;
  final String title;
  final List<(String, String, IconData)> items;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: title,
      currentRoute: route,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          ...items.map((item) => SectionCard(title: item.$1, description: item.$2, icon: item.$3)),
        ],
      ),
    );
  }
}
