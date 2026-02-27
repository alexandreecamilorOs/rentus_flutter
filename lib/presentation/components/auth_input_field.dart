import 'package:flutter/material.dart';
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
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
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
    final bool hasError = widget.error != null && widget.error!.isNotEmpty;

    final Color containerColor = hasError
        ? AppColors.error.withOpacity(0.08)
        : _isFocused
            ? AppColors.white
            : AppColors.inputBg;

    final Color borderColor = hasError
        ? AppColors.error
        : _isFocused
            ? AppColors.primary
            : AppColors.border;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: borderColor, width: _isFocused || hasError ? 2 : 1),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onValueChange,
              obscureText: widget.isPassword && !widget.isPasswordVisible,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: TextStyle(
                  color: hasError ? AppColors.error : AppColors.textSecondary,
                ),
                prefixIcon: Icon(
                  widget.leadingIcon,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: widget.isPassword
                    ? IconButton(
                        icon: Icon(
                          widget.isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: widget.onTogglePasswordVisibility,
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 16),
              child: Text(
                widget.error!,
                style: const TextStyle(
                  color: AppColors.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
