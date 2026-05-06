import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_top_bar.dart';
import 'verification_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const String routeName = '/forgot-password';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool phoneFilled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AuthTopBar(title: 'Forgot password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
        child: Column(
          children: [
            _PhoneCard(
              phoneFilled: phoneFilled,
              onPhoneChanged: (value) =>
                  setState(() => phoneFilled = value.trim().isNotEmpty),
              onSend: () =>
                  Navigator.pushNamed(context, VerificationCodePage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneCard extends StatelessWidget {
  const _PhoneCard({
    required this.phoneFilled,
    required this.onPhoneChanged,
    required this.onSend,
  });

  final bool phoneFilled;
  final ValueChanged<String> onPhoneChanged;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return _AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Type your phone number',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          AuthTextField(
            hint: '(+62)',
            keyboardType: TextInputType.phone,
            onChanged: onPhoneChanged,
          ),
          const SizedBox(height: 24),
          const Text(
            'We texted you a code to verify your\nphone number',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 22),
          AuthButton(label: 'Send', onPressed: phoneFilled ? onSend : null),
        ],
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
