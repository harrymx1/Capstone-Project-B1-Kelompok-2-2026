import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';

class ResetSuccessIllustration extends StatelessWidget {
  const ResetSuccessIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with actual illustration asset from design.
    return SizedBox(
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 18,
            child: Container(
              width: 230,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.softLavender,
                borderRadius: BorderRadius.all(Radius.elliptical(115, 22)),
              ),
            ),
          ),
          Positioned(
            left: 36,
            bottom: 42,
            child: Icon(Icons.eco, size: 64, color: Colors.teal.shade300),
          ),
          Positioned(
            right: 30,
            bottom: 42,
            child: Icon(Icons.eco, size: 64, color: Colors.teal.shade300),
          ),
          Positioned(
            bottom: 53,
            child: Container(
              width: 74,
              height: 132,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.check, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
          Positioned(
            right: 74,
            bottom: 55,
            child: Icon(Icons.security, size: 76, color: Colors.indigo.shade500),
          ),
          const Positioned(
            right: 42,
            bottom: 46,
            child: Icon(Icons.lock, size: 48, color: Color(0xFFFFAA21)),
          ),
          const Positioned(
            left: 84,
            bottom: 26,
            child: Icon(Icons.vpn_key_outlined, size: 42, color: Color(0xFFFFAA21)),
          ),
        ],
      ),
    );
  }
}
