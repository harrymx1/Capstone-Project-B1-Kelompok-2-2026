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
import '../../features/transfer/models/transfer_draft.dart';
import '../../features/transfer/pages/confirm_transfer_page.dart';
import '../../features/transfer/pages/schedule_transfer_page.dart';
import '../../features/transfer/pages/transfer_form_page.dart';
import '../../features/transfer/pages/transfer_page.dart';
import '../../features/transfer/pages/transfer_success_page.dart';
import '../../features/withdrawal/pages/cardless_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String initial = LoginPage.routeName;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        switch (settings.name) {
          case LoginPage.routeName:
            return const LoginPage();
          case SignUpPage.routeName:
            return const SignUpPage();
          case ForgotPasswordPage.routeName:
            return const ForgotPasswordPage();
          case VerificationCodePage.routeName:
            return const VerificationCodePage();
          case ChangePasswordPage.routeName:
            return const ChangePasswordPage();
          case ResetSuccessPage.routeName:
            return const ResetSuccessPage();
          case HomePage.routeName:
            return const HomePage();
          case TransferPage.routeName:
            return const TransferPage();
          case TransferFormPage.routeName:
            return const TransferFormPage();
          case ScheduleTransferPage.routeName:
            return const ScheduleTransferPage();
          case ConfirmTransferPage.routeName:
            return ConfirmTransferPage(
              draft:
                  settings.arguments as TransferDraft? ?? TransferDraft.empty(),
            );
          case TransferSuccessPage.routeName:
            return TransferSuccessPage(
              draft:
                  settings.arguments as TransferDraft? ?? TransferDraft.empty(),
            );
          case BillsTopUpPage.routeName:
            return const BillsTopUpPage();
          case CardlessPage.routeName:
            return const CardlessPage();
          case InvestmentPage.routeName:
            return const InvestmentPage();
          case MoreServicesPage.routeName:
            return const MoreServicesPage();
          default:
            return const LoginPage();
        }
      },
    );
  }
}
