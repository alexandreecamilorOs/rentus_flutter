import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AuthButton extends StatefulWidget {
  final String text;
  final bool enabled;
  final bool isLoading;
  final VoidCallback onClick;

  const AuthButton({
    super.key,
    required this.text,
    this.enabled = true,
    this.isLoading = false,
    required this.onClick,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: false);

    _glowAnimation = Tween<double>(begin: -0.5, end: 1.5).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.fastOutSlowIn),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
      widget.onClick();
    }
  }

  void _handleTapCancel() {
    if (widget.enabled && !widget.isLoading) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _isPressed ? 0.98 : 1.0;
    final bool isDisabled = !widget.enabled || widget.isLoading;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDisabled ? AppColors.primaryDark.withOpacity(0.4) : null,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              if (!isDisabled)
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: const [
                              AppColors.primaryDark,
                              AppColors.primary,
                              Color(0xFF7D512E),
                              AppColors.primaryDark,
                            ],
                            stops: [
                              0.0,
                              _glowAnimation.value - 0.2,
                              _glowAnimation.value,
                              _glowAnimation.value + 0.2,
                            ].map((s) => s.clamp(0.0, 1.0)).toList(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: widget.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.text,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.arrow_forward,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
