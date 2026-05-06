import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/pages/home_page.dart';
import '../widgets/auth_button.dart';
import 'forgot_password_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                              ),
                              color: Colors.white,
                            ),
                            const Spacer(),
                            const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 35),
                        TextField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter User ID',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                            isDense: true,
                            contentPadding: const EdgeInsets.only(bottom: 8),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 54),
                        AuthButton(
                          label: 'Login',
                          inverted: true,
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            HomePage.routeName,
                          ),
                        ),
                        const SizedBox(height: 22),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            ForgotPasswordPage.routeName,
                          ),
                          child: const Text(
                            'I have an account but no user ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        AuthButton(
                          label: 'Register to OCTO',
                          outlined: true,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            SignUpPage.routeName,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Open an account now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const _OctoLogoPlaceholder(),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OctoLogoPlaceholder extends StatelessWidget {
  const _OctoLogoPlaceholder();

  @override
  Widget build(BuildContext context) {
    // TODO: replace with actual OCTO Mobile logo asset from design.
    return Column(
      children: [
        const Icon(
          Icons.account_balance_wallet_rounded,
          color: Colors.white,
          size: 54,
        ),
        const Text(
          'OCTO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 42,
            height: 0.9,
          ),
        ),
        const Text(
          'Mobile',
          style: TextStyle(color: Colors.white, fontSize: 24, height: 1),
        ),
        Text(
          'BY CIMB NIAGA',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.88),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
