import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_top_bar.dart';
import '../widgets/register_illustration.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const String routeName = '/sign-up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthTopBar(title: 'Sign up', redBackground: true),
      body: Column(
        children: [
          Container(
            height: 30,
            decoration: const BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Welcome,', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 3),
                  const Text(
                    "Let's get started by creating your account!",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 26),
                  const RegisterIllustration(),
                  const SizedBox(height: 26),
                  const AuthTextField(hint: 'Name'),
                  const SizedBox(height: 12),
                  const AuthTextField(hint: 'User ID'),
                  const SizedBox(height: 12),
                  const AuthTextField(
                    hint: 'Password',
                    obscureText: true,
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: agreed,
                          activeColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.border),
                          onChanged: (value) {
                            setState(() => agreed = value ?? false);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'By creating an account your aggree\nto our ',
                            children: [
                              TextSpan(
                                text: 'Term and Conditions',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(fontSize: 12, height: 1.35),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AuthButton(
                    label: 'Sign up',
                    onPressed: agreed ? () {} : null,
                  ),
                  const SizedBox(height: 26),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginPage.routeName,
                        (_) => false,
                      ),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Have an account?   ',
                          style: TextStyle(color: AppColors.text, fontSize: 12),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
