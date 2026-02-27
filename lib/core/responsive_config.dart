import 'package:flutter/material.dart';

class ResponsiveConfig {
  static const double _designWidth = 390;
  static const double _designHeight = 844;

  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double getProportionateScreenWidth(double inputWidth) {
    return (inputWidth / _designWidth) * screenWidth;
  }

  static double getProportionateScreenHeight(double inputHeight) {
    return (inputHeight / _designHeight) * screenHeight;
  }

  static double fontSize(double size) {
    final scaled = getProportionateScreenWidth(size);
    return scaled.clamp(size * 0.85, size * 1.25);
  }
}
