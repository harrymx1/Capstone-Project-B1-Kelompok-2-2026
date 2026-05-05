import 'package:flutter/material.dart';

import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_top_bar.dart';
import 'reset_success_page.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  static const String routeName = '/change-password';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const AuthTopBar(title: 'Change password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
        child: Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Type your new password',
                style: TextStyle(
                  color: Color(0xFF8D8D8D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const AuthTextField(
                hint: '',
                initialValue: '************',
                obscureText: true,
                suffixIcon: Icon(Icons.visibility),
              ),
              const SizedBox(height: 18),
              const Text(
                'Confirm password',
                style: TextStyle(
                  color: Color(0xFF8D8D8D),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const AuthTextField(
                hint: '',
                initialValue: '************',
                obscureText: true,
                suffixIcon: Icon(Icons.visibility),
              ),
              const SizedBox(height: 36),
              AuthButton(
                label: 'Change password',
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  ResetSuccessPage.routeName,
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
