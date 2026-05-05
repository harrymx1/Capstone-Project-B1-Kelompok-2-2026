import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_top_bar.dart';
import 'change_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const String routeName = '/forgot-password';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool phoneFilled = false;
  bool codeSent = false;
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
            _PhoneCard(
              phoneFilled: phoneFilled,
              codeSent: codeSent,
              onPhoneChanged: (value) => setState(
                () => phoneFilled = value.trim().isNotEmpty,
              ),
              onSend: () => setState(() => codeSent = true),
            ),
            if (codeSent) ...[
              const SizedBox(height: 26),
              _CodeCard(
                codeFilled: codeFilled,
                onResend: () {},
                onTapCode: () => setState(() => codeFilled = true),
                onChangePassword: codeFilled
                    ? () => Navigator.pushNamed(context, ChangePasswordPage.routeName)
                    : null,
              ),
              const SizedBox(height: 36),
              TextButton(
                onPressed: () => setState(() {
                  codeSent = false;
                  codeFilled = false;
                }),
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
          ],
        ),
      ),
    );
  }
}

class _PhoneCard extends StatelessWidget {
  const _PhoneCard({
    required this.codeSent,
    required this.phoneFilled,
    required this.onPhoneChanged,
    required this.onSend,
  });

  final bool codeSent;
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
            initialValue: codeSent ? '(+62) 0398829xxx' : null,
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
          AuthButton(
            label: 'Send',
            onPressed: phoneFilled || codeSent ? onSend : null,
          ),
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.codeFilled,
    required this.onResend,
    required this.onTapCode,
    required this.onChangePassword,
  });

  final bool codeFilled;
  final VoidCallback onResend;
  final VoidCallback onTapCode;
  final VoidCallback? onChangePassword;

  @override
  Widget build(BuildContext context) {
    return _AuthCard(
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
                child: GestureDetector(
                  onTap: onTapCode,
                  child: AbsorbPointer(
                    child: AuthTextField(
                      hint: 'Code',
                      initialValue: codeFilled ? '8422' : null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 88,
                child: AuthButton(label: 'Resend', onPressed: onResend),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text.rich(
            TextSpan(
              text: 'We texted you a code to verify your\nphone number ',
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
            onPressed: onChangePassword,
          ),
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
