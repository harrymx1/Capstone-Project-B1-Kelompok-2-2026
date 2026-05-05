import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/reset_success_illustration.dart';
import 'login_page.dart';

class ResetSuccessPage extends StatelessWidget {
  const ResetSuccessPage({super.key});

  static const String routeName = '/reset-success';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    LoginPage.routeName,
                    (_) => false,
                  ),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              const SizedBox(height: 24),
              const ResetSuccessIllustration(),
              const SizedBox(height: 28),
              const Text(
                'Change password successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'You have successfully change password.\nPlease use the new password when Sign in.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              AuthButton(
                label: 'Ok',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginPage.routeName,
                  (_) => false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
