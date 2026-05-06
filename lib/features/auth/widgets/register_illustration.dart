import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class RegisterIllustration extends StatelessWidget {
  const RegisterIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 106,
            height: 106,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.softLavender,
            ),
          ),
          const Positioned(
            top: 18,
            left: 118,
            child: _Dot(size: 9, color: AppColors.primary),
          ),
          const Positioned(
            right: 58,
            top: 35,
            child: _Dot(size: 25, color: AppColors.primary),
          ),
          const Positioned(
            left: 58,
            top: 65,
            child: _Dot(size: 9, color: Color(0xFF51CFBF)),
          ),
          const Positioned(
            left: 91,
            bottom: 16,
            child: _Dot(size: 18, color: Color(0xFFFFAA21)),
          ),
          const Positioned(
            right: 75,
            bottom: 18,
            child: _Dot(size: 9, color: Color(0xFF008BEA)),
          ),
          Container(
            width: 48,
            height: 78,
            decoration: BoxDecoration(
              color: const Color(0xFF5A58C9),
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            // TODO: replace with actual asset from design.
            child: const Icon(
              Icons.manage_accounts_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
