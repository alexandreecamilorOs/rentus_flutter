import 'package:flutter/material.dart';

/// Onda orgánica premium con amplitud amplia y movimiento suave.
///
/// Diseñada para sentirse fluida (no lineal):
/// - Curva `easeInOutCubic`
/// - Recorrido lento (~1.5s)
/// - Núcleo intenso y bordes difusos
class LuxuryWaveOverlay extends StatelessWidget {
  final Animation<double> animation;
  final Color color;

  const LuxuryWaveOverlay({
    super.key,
    required this.animation,
    this.color = const Color(0xFFFFD88A),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final travel = Curves.easeInOutCubic.transform(animation.value);
        final breathing = 0.78 + (0.22 * Curves.easeInOut.transform(animation.value));

        // Recorre de 0.18 a 0.82 del ancho del botón.
        final center = 0.18 + (0.64 * travel);

        // Amplitud aprox 60% con borde suave y núcleo más intenso.
        final s1 = (center - 0.34).clamp(0.0, 1.0);
        final s2 = (center - 0.16).clamp(0.0, 1.0);
        final s3 = center.clamp(0.0, 1.0);
        final s4 = (center + 0.16).clamp(0.0, 1.0);
        final s5 = (center + 0.34).clamp(0.0, 1.0);

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.transparent,
                color.withOpacity(0.08 * breathing),
                color.withOpacity(0.28 * breathing),
                color.withOpacity(0.1 * breathing),
                Colors.transparent,
              ],
              stops: [s1, s2, s3, s4, s5],
            ),
          ),
        );
      },
    );
  }
}
