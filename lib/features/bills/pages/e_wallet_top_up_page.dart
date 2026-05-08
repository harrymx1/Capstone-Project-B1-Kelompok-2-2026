import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/top_up_draft.dart';
import 'top_up_success_page.dart';

class EWalletTopUpPage extends StatefulWidget {
  const EWalletTopUpPage({super.key, required this.walletName});

  static const String routeName = '/e-wallet-top-up';

  final String walletName;

  @override
  State<EWalletTopUpPage> createState() => _EWalletTopUpPageState();
}

class _EWalletTopUpPageState extends State<EWalletTopUpPage> {
  final destinationController = TextEditingController(text: '081275432155');
  final amountController = TextEditingController(text: 'IDR 20.000');

  Map<String, dynamic>? get _user {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;

    if (routeArgs is Map<String, dynamic> && routeArgs.containsKey('nama')) {
      return routeArgs;
    }

    return null;
  }

  @override
  void dispose() {
    destinationController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _TopUpHeader(title: widget.walletName),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Top Up from',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _AccountCard(),
                    const SizedBox(height: 18),
                    const Text(
                      'Transaction Details',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _LabeledField(
                      label: 'Mobile Number',
                      child: _InputField(
                        controller: destinationController,
                        keyboardType: TextInputType.phone,
                        suffixIcon: Icons.favorite_border_rounded,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      label: 'Amount',
                      child: _InputField(controller: amountController),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: _PrimaryButton(
                label: 'Continue',
                onPressed: () {
                  final draft = TopUpDraft(
                    walletName: widget.walletName,
                    destinationNumber: destinationController.text,
                    amount: amountController.text,
                  );

                  _showPinSheet(draft);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPinSheet(TopUpDraft draft) {
    final pageContext = context;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 18,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Confirm your transaction',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Enter your pin number',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 28),
                const _PinDots(),
                const SizedBox(height: 26),
                TextField(
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'PIN',
                    enabledBorder: _outlineBorder(AppColors.border),
                    focusedBorder: _outlineBorder(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                _PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      pageContext,
                      TopUpSuccessPage.routeName,
                      arguments: {
                        'draft': draft,
                        'user': _user,
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopUpHeader extends StatelessWidget {
  const _TopUpHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.white,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({this.user});

  final Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    final userName = user?['nama'] ?? 'David';

    return Container(
      width: double.infinity,
      height: 104,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.credit_card_rounded, color: Colors.white, size: 52),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OCTO Pay (*****6147)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Balance\nRp 67.670',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
        enabledBorder: _outlineBorder(AppColors.border),
        focusedBorder: _outlineBorder(AppColors.primary),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  const _PinDots();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PinDot(),
        _PinDot(),
        _PinDot(),
        _PinDot(),
        _PinDot(),
        _PinDot(),
      ],
    );
  }
}

class _PinDot extends StatelessWidget {
  const _PinDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Color(0xFFBCC2CC),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

OutlineInputBorder _outlineBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );
}
