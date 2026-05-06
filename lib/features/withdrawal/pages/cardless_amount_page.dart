import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/withdrawal_draft.dart';
import 'cardless_summary_page.dart';

class CardlessAmountPage extends StatefulWidget {
  const CardlessAmountPage({super.key, required this.location});

  static const String routeName = '/cardless-amount';

  final String location;

  @override
  State<CardlessAmountPage> createState() => _CardlessAmountPageState();
}

class _CardlessAmountPageState extends State<CardlessAmountPage> {
  final customAmountController = TextEditingController();

  String selectedAmount = 'Rp 150.000';

  static const amounts = [
    'Rp 50.000',
    'Rp 100.000',
    'Rp 150.000',
    'Rp 200.000',
    'Rp 250.000',
    'Other',
  ];

  @override
  void dispose() {
    customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cardless Withdrawal'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 14, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: _WithdrawalIllustration()),
                    const SizedBox(height: 12),
                    const _AccountCard(),
                    const SizedBox(height: 12),
                    const Text(
                      'Withdrawal Amount',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      itemCount: amounts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.65,
                          ),
                      itemBuilder: (context, index) {
                        final amount = amounts[index];
                        return _AmountChip(
                          label: amount,
                          selected: amount == selectedAmount,
                          onTap: () => setState(() => selectedAmount = amount),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Withdrawal Amount',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: customAmountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter Amount',
                        hintStyle: const TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        enabledBorder: _outlineBorder(AppColors.border),
                        focusedBorder: _outlineBorder(AppColors.primary),
                      ),
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
                  final customAmount = customAmountController.text.trim();
                  final draft = WithdrawalDraft(
                    location: widget.location,
                    amount: selectedAmount == 'Other' && customAmount.isNotEmpty
                        ? customAmount
                        : selectedAmount,
                  );

                  Navigator.pushNamed(
                    context,
                    CardlessSummaryPage.routeName,
                    arguments: draft,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WithdrawalIllustration extends StatelessWidget {
  const _WithdrawalIllustration();

  @override
  Widget build(BuildContext context) {
    // TODO: replace with actual asset
    return SizedBox(
      height: 156,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 6,
            child: Container(
              width: 250,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColors.softLavender,
                borderRadius: BorderRadius.all(Radius.elliptical(125, 23)),
              ),
            ),
          ),
          const Positioned(
            left: 58,
            bottom: 36,
            child: Icon(
              Icons.account_balance_wallet,
              color: Colors.blue,
              size: 70,
            ),
          ),
          const Positioned(
            right: 68,
            bottom: 48,
            child: Icon(Icons.phone_iphone, color: AppColors.primary, size: 78),
          ),
          const Positioned(
            left: 76,
            bottom: 14,
            child: Icon(Icons.paid, color: Color(0xFFFFB02E), size: 44),
          ),
          const Positioned(
            right: 44,
            bottom: 58,
            child: Icon(
              Icons.monetization_on,
              color: Color(0xFFFFB02E),
              size: 42,
            ),
          ),
          Positioned(
            left: 36,
            bottom: 25,
            child: Icon(Icons.eco, color: Colors.teal.shade300, size: 54),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 112,
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
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: replace with actual asset
          Icon(Icons.credit_card_rounded, color: Colors.white, size: 52),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'OCTO Pay (*****6147)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'David',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                Spacer(),
                Text(
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

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
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
