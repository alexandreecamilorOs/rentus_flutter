import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MessageItem {
  final String title;
  final String description;

  MessageItem({required this.title, required this.description});
}

class DynamicMessageSection extends StatefulWidget {
  const DynamicMessageSection({super.key});

  @override
  State<DynamicMessageSection> createState() => _DynamicMessageSectionState();
}

class _DynamicMessageSectionState extends State<DynamicMessageSection> {
  int _selectedIndex = 0;

  final List<MessageItem> messages = [
    MessageItem(
      title: "Búsqueda inteligente",
      description:
          "Usa nuestros filtros avanzados para encontrar exactamente lo que necesitas en segundos",
    ),
    MessageItem(
      title: "Encuentra tu hogar ideal",
      description:
          "Accede a miles de propiedades disponibles en tu ciudad y comienza tu búsqueda hoy mismo",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              messages[_selectedIndex].title,
              key: ValueKey<int>(_selectedIndex),
              style: const TextStyle(
                fontSize: 42,
                height: 1.1, // 46 / 42
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              messages[_selectedIndex].description,
              key: ValueKey<int>(_selectedIndex),
              style: const TextStyle(
                fontSize: 18,
                height: 1.55, // 28 / 18
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            spacing: 10,
            children: List.generate(messages.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: index == _selectedIndex
                        ? AppColors.dotActive
                        : AppColors.dotInactive,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
