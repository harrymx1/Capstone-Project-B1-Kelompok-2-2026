import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    this.onPressed,
    this.outlined = false,
    this.inverted = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool outlined;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: inverted
              ? Colors.white
              : outlined
              ? Colors.transparent
              : isEnabled
              ? AppColors.primary
              : AppColors.disabledFill,
          foregroundColor: inverted
              ? AppColors.primary
              : outlined
              ? Colors.white
              : isEnabled
              ? Colors.white
              : Colors.white.withValues(alpha: 0.85),
          side: BorderSide(
            color: outlined ? Colors.white : Colors.transparent,
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}
