import 'package:flutter/material.dart';

import '../../core/responsive_config.dart';
import '../../core/theme/app_colors.dart';

class AuthInputField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onValueChange;
  final String label;
  final IconData leadingIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePasswordVisibility;
  final String? error;

  const AuthInputField({
    super.key,
    required this.value,
    required this.onValueChange,
    required this.label,
    required this.leadingIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePasswordVisibility,
    this.error,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(covariant AuthInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && _controller.text != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null && widget.error!.isNotEmpty;

    // Premium Dark Colors
    final containerColor = hasError
        ? AppColors.error.withOpacity(0.15)
        : _isFocused
            ? const Color(0x26FFFFFF) // 15% White
            : const Color(0x0DFFFFFF); // 5% White

    final borderColor = hasError
        ? AppColors.error
        : _isFocused
            ? const Color(0xFFFFD59A) // Majestic Gold
            : const Color(0x33FFFFFF); // Subtle White Border

    final iconAndLabelColor = hasError
        ? AppColors.error
        : _isFocused
            ? const Color(0xFFFFD59A)
            : const Color(0x99FFFFFF); // 60% White text

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConfig.getProportionateScreenHeight(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(
                ResponsiveConfig.getProportionateScreenWidth(18),
              ),
              border: Border.all(
                color: borderColor,
                width: _isFocused ? 1.5 : 1,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: borderColor.withOpacity(0.25),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onValueChange,
              obscureText: widget.isPassword && !widget.isPasswordVisible,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              cursorColor: const Color(0xFFFFD59A),
              decoration: InputDecoration(
                filled: false,
                labelText: widget.label,
                labelStyle: TextStyle(
                  color: iconAndLabelColor,
                  fontWeight: _isFocused ? FontWeight.w600 : FontWeight.w400,
                ),
                prefixIcon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    widget.leadingIcon,
                    key: ValueKey(_isFocused),
                    color: iconAndLabelColor,
                  ),
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          widget.isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color(0x99FFFFFF),
                        ),
                        onPressed: widget.onTogglePasswordVisibility,
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ResponsiveConfig.getProportionateScreenWidth(16),
                  vertical: ResponsiveConfig.getProportionateScreenHeight(18),
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: EdgeInsets.only(
                top: ResponsiveConfig.getProportionateScreenHeight(6),
                left: ResponsiveConfig.getProportionateScreenWidth(16),
              ),
              child: Text(
                widget.error!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: ResponsiveConfig.fontSize(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
