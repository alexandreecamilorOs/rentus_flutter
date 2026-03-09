import 'package:flutter/material.dart';
import 'upward_particles.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Cinematic Background (Matching Home)
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0D0A09),
                Color(0xFF1E1410),
                Color(0xFF2E1D17),
              ],
            ),
          ),
        ),
        // 2. Upward Particles
        const UpwardParticles(particleCount: 20),

        // 3. Child content
        SafeArea(child: child),
      ],
    );
  }
}
