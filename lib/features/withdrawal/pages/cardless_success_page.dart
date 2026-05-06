import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/pages/home_page.dart';

class CardlessSuccessPage extends StatelessWidget {
  const CardlessSuccessPage({super.key});

  static const String routeName = '/cardless-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
          child: Column(
            children: [
              const Spacer(),
              const _WithdrawalSuccessIllustration(),
              const SizedBox(height: 38),
              const Text(
                'Successful withdrawal!',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'You have successfully withdrawn money!\nPlease check the balance in the card\nmanagement section.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
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
    );
  }
}

class _WithdrawalSuccessIllustration extends StatelessWidget {
  const _WithdrawalSuccessIllustration();

  @override
  Widget build(BuildContext context) {
    // TODO: replace with actual asset
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 8,
            child: Container(
              width: 260,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.softLavender,
                borderRadius: BorderRadius.all(Radius.elliptical(130, 24)),
              ),
            ),
          ),
          const Positioned(
            left: 58,
            bottom: 42,
            child: Icon(
              Icons.account_balance_wallet,
              color: Colors.blue,
              size: 76,
            ),
          ),
          const Positioned(
            right: 62,
            bottom: 54,
            child: Icon(Icons.phone_iphone, color: AppColors.primary, size: 88),
          ),
          const Positioned(
            left: 70,
            bottom: 18,
            child: Icon(Icons.paid, color: Color(0xFFFFB02E), size: 48),
          ),
          const Positioned(
            right: 38,
            bottom: 64,
            child: Icon(
              Icons.monetization_on,
              color: Color(0xFFFFB02E),
              size: 44,
            ),
          ),
          Positioned(
            left: 36,
            bottom: 32,
            child: Icon(Icons.eco, color: Colors.teal.shade300, size: 58),
          ),
        ],
      ),
    );
  }
}
