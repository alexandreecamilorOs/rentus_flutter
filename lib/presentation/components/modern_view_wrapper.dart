import 'package:flutter/material.dart';

extension ModernViewWrapper on Widget {
  Widget modernWrapped() {
    return _ModernViewWrapper(child: this);
  }
}

class _ModernViewWrapper extends StatefulWidget {
  final Widget child;
  const _ModernViewWrapper({required this.child});

  @override
  State<_ModernViewWrapper> createState() => _ModernViewWrapperState();
}

class _ModernViewWrapperState extends State<_ModernViewWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeOutBack.transform(_controller.value);
          return Transform.translate(
            offset: Offset(0, (1 - t) * 16),
            child: Transform.scale(
              scale: 0.985 + (t * 0.015),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
