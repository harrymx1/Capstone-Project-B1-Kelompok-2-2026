import 'package:flutter/material.dart';

import '../../features/auth/pages/change_password_page.dart';
import '../../features/auth/pages/forgot_password_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/reset_success_page.dart';
import '../../features/auth/pages/sign_up_page.dart';
import '../../features/auth/pages/verification_code_page.dart';
import '../../features/bills/models/electricity_draft.dart';
import '../../features/bills/pages/bills_menu_placeholder_page.dart';
import '../../features/bills/pages/bills_top_up_page.dart';
import '../../features/bills/pages/electricity_bill_page.dart';
import '../../features/bills/pages/electricity_success_page.dart';
import '../../features/bills/pages/e_wallet_top_up_page.dart';
import '../../features/bills/pages/top_up_success_page.dart';
import '../../features/home/pages/bottom_nav_placeholder_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/investment/pages/investment_page.dart';
import '../../features/others/pages/more_services_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/transfer/models/transfer_draft.dart';
import '../../features/transfer/pages/confirm_transfer_page.dart';
import '../../features/transfer/pages/schedule_transfer_page.dart';
import '../../features/transfer/pages/transfer_form_page.dart';
import '../../features/transfer/pages/transfer_page.dart';
import '../../features/transfer/pages/transfer_success_page.dart';
import '../../features/withdrawal/models/withdrawal_draft.dart';
import '../../features/withdrawal/pages/cardless_amount_page.dart';
import '../../features/withdrawal/pages/cardless_page.dart';
import '../../features/withdrawal/pages/cardless_success_page.dart';
import '../../features/withdrawal/pages/cardless_summary_page.dart';
import '../../features/wealth/pages/wealth_page.dart';

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
          case BottomNavPlaceholderPage.routeName:
            return BottomNavPlaceholderPage(
              title: settings.arguments as String? ?? 'Menu',
            );
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
          case BillsMenuPlaceholderPage.routeName:
            return BillsMenuPlaceholderPage(
              title: settings.arguments as String? ?? 'Bills & Top Up',
            );
          case EWalletTopUpPage.routeName:
            return EWalletTopUpPage(
              walletName: settings.arguments as String? ?? 'GoPay',
            );
          case TopUpSuccessPage.routeName:
            return const TopUpSuccessPage();
          case ElectricityBillPage.routeName:
            return ElectricityBillPage(
              type: settings.arguments as String? ?? 'Electricity Bill',
            );
          case ElectricitySuccessPage.routeName:
            return ElectricitySuccessPage(
              draft:
                  settings.arguments as ElectricityDraft? ??
                  ElectricityDraft.empty(),
            );
          case CardlessPage.routeName:
            return const CardlessPage();
          case CardlessAmountPage.routeName:
            return CardlessAmountPage(
              location: settings.arguments as String? ?? 'CIMB NIAGA ATM',
            );
          case CardlessSummaryPage.routeName:
            return CardlessSummaryPage(
              draft:
                  settings.arguments as WithdrawalDraft? ??
                  WithdrawalDraft.empty(),
            );
          case CardlessSuccessPage.routeName:
            return const CardlessSuccessPage();
          case InvestmentPage.routeName:
            return const InvestmentPage();
          case WealthPage.routeName:
            return const WealthPage();
          case MoreServicesPage.routeName:
            return const MoreServicesPage();
          case ProfilePage.routeName:
            return const ProfilePage();
          default:
            return const LoginPage();
        }
      },
    );
  }
}
