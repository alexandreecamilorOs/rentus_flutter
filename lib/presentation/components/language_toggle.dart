import 'dart:ui';
import 'package:flutter/material.dart';

class LanguageToggle extends StatefulWidget {
  final Function(String)? onLanguageChanged;
  final String initialLanguage;

  const LanguageToggle({
    super.key,
    this.onLanguageChanged,
    this.initialLanguage = 'es',
  });

  @override
  State<LanguageToggle> createState() => _LanguageToggleState();
}

class _LanguageToggleState extends State<LanguageToggle> {
  late String _currentLanguage;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.initialLanguage;
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'es' ? 'en' : 'es';
    });
    widget.onLanguageChanged?.call(_currentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _toggleLanguage,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFDA9C5F).withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // Track
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildOption('EN', _currentLanguage == 'en'),
                        _buildOption('ES', _currentLanguage == 'es'),
                      ],
                    ),
                  ),
                ),
              ),

              // Slider
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                left: _currentLanguage == 'en' ? 4 : 45, // Adjusted for padding
                top: 4,
                bottom: 4,
                child: Container(
                  width: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFDA9C5F), Color(0xFFB8791F)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDA9C5F).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Gloss overlay for slider
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.elasticOut,
                left: _currentLanguage == 'en' ? 4 : 45,
                top: 4,
                bottom: 4,
                child: IgnorePointer(
                  child: Container(
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: RadialGradient(
                        center: const Alignment(-0.5, -0.5),
                        radius: 1.0,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String text, bool isActive) {
    return Container(
      width: 40,
      height: 28,
      alignment: Alignment.center,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.5,
          shadows: isActive
              ? [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  )
                ]
              : [],
        ),
        child: Text(text),
      ),
    );
  }
}
