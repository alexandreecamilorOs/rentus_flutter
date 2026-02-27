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
    _focusNode.addListener(() => setState(() => _isFocused = _focusNode.hasFocus));
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
    final gradient = hasError
        ? const [Color(0x66EF4444), Color(0x99EF4444)]
        : _isFocused
            ? const [Color(0xAAFFD672), Color(0xAA7D512E)]
            : const [Color(0x66FFFFFF), Color(0x22FFFFFF)];

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveConfig.getProportionateScreenHeight(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            padding: EdgeInsets.all(ResponsiveConfig.getProportionateScreenWidth(1.2)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(16)),
              gradient: LinearGradient(colors: gradient),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: ResponsiveConfig.getProportionateScreenWidth(18),
                  offset: Offset(0, ResponsiveConfig.getProportionateScreenHeight(8)),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2A1D18).withOpacity(_isFocused ? 0.72 : 0.58),
                borderRadius: BorderRadius.circular(ResponsiveConfig.getProportionateScreenWidth(15)),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: widget.onValueChange,
                obscureText: widget.isPassword && !widget.isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: widget.label,
                  labelStyle: TextStyle(
                    color: hasError ? AppColors.error : const Color(0xFFEADFCF),
                    fontSize: ResponsiveConfig.fontSize(14),
                  ),
                  prefixIcon: Icon(widget.leadingIcon, color: const Color(0xFFEADFCF)),
                  suffixIcon: widget.isPassword
                      ? IconButton(
                          icon: Icon(
                            widget.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: const Color(0xFFEADFCF),
                          ),
                          onPressed: widget.onTogglePasswordVisibility,
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveConfig.getProportionateScreenWidth(16),
                    vertical: ResponsiveConfig.getProportionateScreenHeight(15),
                  ),
                ),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: EdgeInsets.only(
                top: ResponsiveConfig.getProportionateScreenHeight(4),
                left: ResponsiveConfig.getProportionateScreenWidth(16),
              ),
              child: Text(
                widget.error!,
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: ResponsiveConfig.fontSize(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
