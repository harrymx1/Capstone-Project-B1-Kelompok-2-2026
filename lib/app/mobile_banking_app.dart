import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../features/auth/pages/change_password_page.dart';
import '../features/auth/pages/forgot_password_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/reset_success_page.dart';
import '../features/auth/pages/sign_up_page.dart';
import '../features/auth/pages/verification_code_page.dart';
import '../features/home/pages/home_page.dart';

class MobileBankingApp extends StatelessWidget {
  const MobileBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Banking UI',
      theme: AppTheme.light(),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        SignUpPage.routeName: (_) => const SignUpPage(),
        ForgotPasswordPage.routeName: (_) => const ForgotPasswordPage(),
        VerificationCodePage.routeName: (_) => const VerificationCodePage(),
        ChangePasswordPage.routeName: (_) => const ChangePasswordPage(),
        ResetSuccessPage.routeName: (_) => const ResetSuccessPage(),
        HomePage.routeName: (_) => const HomePage(),
      },
    );
  }
}
