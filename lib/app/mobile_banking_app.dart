import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../features/auth/pages/change_password_page.dart';
import '../features/auth/pages/forgot_password_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/reset_success_page.dart';
import '../features/auth/pages/sign_up_page.dart';
import '../features/auth/pages/verification_code_page.dart';
import '../features/home/pages/bills_top_up_page.dart';
import '../features/home/pages/cardless_page.dart';
import '../features/home/pages/home_page.dart';
import '../features/home/pages/investment_page.dart';
import '../features/home/pages/more_services_page.dart';
import '../features/home/pages/transfer_page.dart';

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
        TransferPage.routeName: (_) => const TransferPage(),
        BillsTopUpPage.routeName: (_) => const BillsTopUpPage(),
        CardlessPage.routeName: (_) => const CardlessPage(),
        InvestmentPage.routeName: (_) => const InvestmentPage(),
        MoreServicesPage.routeName: (_) => const MoreServicesPage(),
      },
    );
  }
}
