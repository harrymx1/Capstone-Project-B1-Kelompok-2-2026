import 'package:flutter/material.dart';

import '../../../core/services/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../models/electricity_draft.dart';
import 'electricity_success_page.dart';

class ElectricityBillPage extends StatefulWidget {
  const ElectricityBillPage({super.key, required this.type});

  static const String routeName = '/electricity-bill';

  final String type;

  @override
  State<ElectricityBillPage> createState() => _ElectricityBillPageState();
}

class _ElectricityBillPageState extends State<ElectricityBillPage> {
  final meterController = TextEditingController(text: '081275432155');

  String? selectedAmount;

  static const amounts = [
    'Rp 50.000',
    'Rp 100.000',
    'Rp 200.000',
    'Rp 500.000',
    'Rp 1.000.000',
    'Rp 5.000.000',
    'Rp 10.000.000',
  ];

  @override
  void dispose() {
    meterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.type;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _ElectricityHeader(title: title),
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
                      label: 'Meter Numbe/IDPEL',
                      child: _InputField(
                        controller: meterController,
                        keyboardType: TextInputType.number,
                        suffixIcon: Icons.favorite_border_rounded,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _LabeledField(
                      label: 'Amount',
                      child: _AmountPickerField(
                        value: selectedAmount,
                        onTap: _showAmountPicker,
                      ),
                    ),
                    const SizedBox(height: 120),
                    const Text(
                      'Promo Available',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _PromoCode(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: _PrimaryButton(
                label: 'Continue',
                onPressed: () {
                  final draft = ElectricityDraft(
                    type: widget.type,
                    meterNumber: meterController.text,
                    amount: selectedAmount ?? 'Rp 100.000',
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

  void _showAmountPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Top Up Amount',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: amounts.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: Color(0xFFE6E6E6)),
                    itemBuilder: (context, index) {
                      final amount = amounts[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          amount,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () {
                          setState(() => selectedAmount = amount);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPinSheet(ElectricityDraft draft) {
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
                      ElectricitySuccessPage.routeName,
                      arguments: draft,
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

class _ElectricityHeader extends StatelessWidget {
  const _ElectricityHeader({required this.title});

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
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    final userName = UserSession.userName;

    return Container(
      width: double.infinity,
      height: 104,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: replace with actual asset
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
                  style: const TextStyle(color: Colors.white, fontSize: 11),
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

class _AmountPickerField extends StatelessWidget {
  const _AmountPickerField({required this.value, required this.onTap});

  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? 'Select amount',
                style: TextStyle(
                  color: value == null
                      ? const Color(0xFFC4C4C4)
                      : AppColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.unfold_more_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _PromoCode extends StatelessWidget {
  const _PromoCode();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'HEMATPLN2',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            'APPLY',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
