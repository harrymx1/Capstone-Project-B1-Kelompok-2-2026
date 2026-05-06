import 'package:flutter/material.dart';

import '../../features/auth/pages/change_password_page.dart';
import '../../features/auth/pages/forgot_password_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/reset_success_page.dart';
import '../../features/auth/pages/sign_up_page.dart';
import '../../features/auth/pages/verification_code_page.dart';
import '../../features/bills/pages/bills_top_up_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/investment/pages/investment_page.dart';
import '../../features/others/pages/more_services_page.dart';
import '../../features/transfer/pages/transfer_page.dart';
import '../../features/withdrawal/pages/cardless_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String initial = LoginPage.routeName;

  static Map<String, WidgetBuilder> routes = {
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
  };
}
