import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveConfig {
  ResponsiveConfig._();

  static const double _smallMobileWidth = 360;
  static const double _tabletWidth = 600;

  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;

  static bool get isSmallMobile => screenWidth < _smallMobileWidth;
  static bool get isMobile => screenWidth >= _smallMobileWidth && screenWidth < _tabletWidth;
  static bool get isTablet => screenWidth >= _tabletWidth;

  static double getProportionateScreenWidth(double inputWidth) => inputWidth.w;

  static double getProportionateScreenHeight(double inputHeight) => inputHeight.h;

  static double fontSize(double size) => size.sp;

  static double adaptiveSpacing({
    required double mobile,
    double? smallMobile,
    double? tablet,
  }) {
    if (isTablet) return (tablet ?? mobile * 1.35).w;
    if (isSmallMobile) return (smallMobile ?? mobile * 0.85).w;
    return mobile.w;
  }

  static EdgeInsets adaptivePadding({
    required double horizontal,
    required double vertical,
    double? smallMobileFactor,
    double? tabletFactor,
  }) {
    final smallFactor = smallMobileFactor ?? 0.85;
    final tabletFactorValue = tabletFactor ?? 1.35;

    final h = isTablet
        ? horizontal * tabletFactorValue
        : isSmallMobile
            ? horizontal * smallFactor
            : horizontal;
    final v = isTablet
        ? vertical * tabletFactorValue
        : isSmallMobile
            ? vertical * smallFactor
            : vertical;

    return EdgeInsets.symmetric(horizontal: h.w, vertical: v.h);
  }

  static T byBreakpoint<T>({
    required T smallMobile,
    required T mobile,
    required T tablet,
  }) {
    if (isTablet) return tablet;
    if (isSmallMobile) return smallMobile;
    return mobile;
  }
}
