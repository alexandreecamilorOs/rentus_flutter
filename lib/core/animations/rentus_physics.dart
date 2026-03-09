import 'package:flutter/animation.dart';
import 'package:flutter/physics.dart';

class RentusPhysics {
  RentusPhysics._();

  static const Duration staggerTight = Duration(milliseconds: 55);
  static const Duration staggerDefault = Duration(milliseconds: 80);
  static const Duration staggerRelaxed = Duration(milliseconds: 100);

  static const SpringDescription soft = SpringDescription(
    mass: 1.0,
    stiffness: 180.0,
    damping: 17.5,
  );

  static const SpringDescription buttonPress = SpringDescription(
    mass: 1.0,
    stiffness: 380.0,
    damping: 28.0,
  );

  static const SpringDescription buttonRelease = SpringDescription(
    mass: 1.0,
    stiffness: 420.0,
    damping: 18.0,
  );

  static const SpringDescription cardEntrance = SpringDescription(
    mass: 1.0,
    stiffness: 250.0,
    damping: 21.0,
  );

  static const SpringDescription navPill = SpringDescription(
    mass: 1.0,
    stiffness: 340.0,
    damping: 24.0,
  );

  static const Tolerance _defaultTolerance = Tolerance(
    distance: 0.0008,
    velocity: 0.0008,
  );

  static SpringSimulation simulation({
    required SpringDescription spring,
    required double from,
    required double to,
    double velocity = 0,
    Tolerance tolerance = _defaultTolerance,
  }) {
    return SpringSimulation(
      spring,
      from,
      to,
      velocity,
      tolerance: tolerance,
    );
  }

  static const Curve settleCurve = Cubic(0.18, 0.9, 0.22, 1.0);
}
