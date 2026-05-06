import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_top_bar.dart';
import 'change_password_page.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key});

  static const String routeName = '/verification-code';

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  bool codeFilled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AuthTopBar(title: 'Forgot password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
        child: Column(
          children: [
            _AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Type a code',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AuthTextField(
                          hint: 'Code',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(
                              () => codeFilled = value.trim().isNotEmpty,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 88,
                        child: AuthButton(label: 'Resend', onPressed: () {}),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text.rich(
                    TextSpan(
                      text:
                          'We texted you a code to verify your\nphone number ',
                      children: [
                        TextSpan(
                          text: '(+62) 0398829xxx',
                          style: TextStyle(
                            color: AppColors.successBlue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "This code will expired 10 minutes after this\nmessage. If you don't get a message.",
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 26),
                  AuthButton(
                    label: 'Change password',
                    onPressed: codeFilled
                        ? () => Navigator.pushNamed(
                            context,
                            ChangePasswordPage.routeName,
                          )
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Change your phone number',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthCard extends StatelessWidget {
  const _AuthCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
