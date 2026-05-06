import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/pages/home_page.dart';
import '../models/electricity_draft.dart';

class ElectricitySuccessPage extends StatelessWidget {
  const ElectricitySuccessPage({super.key, required this.draft});

  static const String routeName = '/electricity-success';

  final ElectricityDraft draft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _SuccessHeader(title: draft.type),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
                child: Column(
                  children: [
                    const _ElectricitySuccessIllustration(),
                    const SizedBox(height: 28),
                    const Text(
                      'Transaction successfully!',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "You've paid your ${draft.type}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomePage.routeName,
                          (_) => false,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessHeader extends StatelessWidget {
  const _SuccessHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _ElectricitySuccessIllustration extends StatelessWidget {
  const _ElectricitySuccessIllustration();

  @override
  Widget build(BuildContext context) {
    // TODO: replace with actual asset
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 10,
            child: Container(
              width: 260,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.softLavender,
                borderRadius: BorderRadius.all(Radius.elliptical(130, 24)),
              ),
            ),
          ),
          Positioned(
            left: 28,
            bottom: 34,
            child: Icon(Icons.eco, color: Colors.teal.shade300, size: 66),
          ),
          const Positioned(
            left: 76,
            bottom: 50,
            child: Icon(Icons.person, color: Color(0xFFFFA726), size: 76),
          ),
          const Positioned(
            right: 72,
            bottom: 48,
            child: Icon(
              Icons.credit_card_rounded,
              color: AppColors.primary,
              size: 92,
            ),
          ),
          const Positioned(
            right: 34,
            bottom: 34,
            child: Icon(Icons.paid, color: Color(0xFFFFB02E), size: 54),
          ),
          const Positioned(
            bottom: 18,
            child: Icon(Icons.verified_user, color: Colors.blue, size: 52),
          ),
        ],
      ),
    );
  }
}
