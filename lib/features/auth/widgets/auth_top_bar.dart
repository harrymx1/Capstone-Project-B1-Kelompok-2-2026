import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class AuthTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthTopBar({
    super.key,
    required this.title,
    this.redBackground = false,
  });

  final String title;
  final bool redBackground;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
        color: redBackground ? AppColors.primaryDark : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: redBackground ? Colors.white : AppColors.text,
                size: 20,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              title,
              style: TextStyle(
                color: redBackground ? Colors.white : AppColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
