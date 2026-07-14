import 'package:flutter/material.dart';
import 'package:cyra/core/design/app_colors.dart';

/// A small lock icon indicating the privacy state.
///
/// Shows a forest green lock when [isLocked] is true and a slate unlock
/// icon when false. Includes a tooltip explaining the state and a subtle
/// animation on state change.
class PrivacyLockIcon extends StatefulWidget {
  /// Whether privacy features are currently active.
  final bool isLocked;

  /// Optional custom tooltip message.
  final String? lockedTooltip;

  /// Optional custom tooltip message for unlocked state.
  final String? unlockedTooltip;

  /// Optional double-tap action, used for emergency lock activation.
  final VoidCallback? onDoubleTap;

  const PrivacyLockIcon({
    super.key,
    this.isLocked = true,
    this.lockedTooltip,
    this.unlockedTooltip,
    this.onDoubleTap,
  });

  @override
  State<PrivacyLockIcon> createState() => _PrivacyLockIconState();
}

class _PrivacyLockIconState extends State<PrivacyLockIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.25), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.25, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isLocked) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(PrivacyLockIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLocked != widget.isLocked) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = widget.isLocked ? AppColors.forestGreen : AppColors.slate;
    final tooltip = widget.isLocked
        ? (widget.lockedTooltip ?? 'Privacy mode is active')
        : (widget.unlockedTooltip ?? 'Privacy mode is inactive');

    return Semantics(
      label: tooltip,
      child: Tooltip(
        message: tooltip,
        preferBelow: false,
        child: GestureDetector(
          onDoubleTap: widget.onDoubleTap,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: isDark ? 0.15 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isLocked ? Icons.lock : Icons.lock_open,
                size: 16,
                color: iconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
