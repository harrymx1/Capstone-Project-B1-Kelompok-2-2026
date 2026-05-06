import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/transfer_draft.dart';
import '../models/transfer_schedule.dart';
import 'confirm_transfer_page.dart';
import 'schedule_transfer_page.dart';

class TransferFormPage extends StatefulWidget {
  const TransferFormPage({super.key});

  static const String routeName = '/transfer-form';

  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> {
  final accountController = TextEditingController(text: '0123456789');
  final amountController = TextEditingController(text: 'IDR 20.000');
  final messageController = TextEditingController(text: 'From yanto');

  String selectedBank = 'CIMB NIAGA';
  TransferSchedule? schedule;

  static const banks = [
    'BCA',
    'BRI',
    'BNI',
    'BANK JAGO',
    'BTN',
    'BANK SAQU',
    'BANK MANDIRI',
    'SEABANK',
    'BSI',
    'BANK JATENG',
    'BANK DKI',
    'BANK JATIM',
    'CIMB NIAGA',
    'BANK SEMARANG',
    'BANK DANAMON',
    'MAYBANK',
    'SUPERBANK',
  ];

  @override
  void dispose() {
    accountController.dispose();
    amountController.dispose();
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transfer'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SourceAccountField(),
                    const SizedBox(height: 28),
                    const Text(
                      'Transfer to',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FieldLabel(
                      label: 'Bank name',
                      child: _TapField(
                        text: selectedBank,
                        onTap: _showBankPicker,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(
                      label: 'Recipient Account',
                      child: _InputField(
                        controller: accountController,
                        keyboardType: TextInputType.number,
                        suffixIcon: Icons.favorite_border_rounded,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(
                      label: 'Amount',
                      child: _InputField(controller: amountController),
                    ),
                    const SizedBox(height: 14),
                    _FieldLabel(
                      label: 'Message (Optional)',
                      child: _InputField(controller: messageController),
                    ),
                    const SizedBox(height: 20),
                    _ScheduleSwitchTile(
                      enabled: schedule != null,
                      onChanged: _openSchedulePage,
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
                  final draft = TransferDraft(
                    destinationBank: selectedBank,
                    accountNumber: accountController.text,
                    amount: amountController.text,
                    message: messageController.text,
                  );

                  Navigator.pushNamed(
                    context,
                    ConfirmTransferPage.routeName,
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

  Future<void> _openSchedulePage(bool value) async {
    if (!value) {
      setState(() => schedule = null);
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      ScheduleTransferPage.routeName,
    );
    if (!mounted) return;

    if (result is TransferSchedule) {
      setState(() => schedule = result);
    }
  }

  void _showBankPicker() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.78,
            child: Column(
              children: [
                const SizedBox(height: 18),
                const Text(
                  'Select Bank Destination',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Select destination bank',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
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
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: banks.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: Color(0xFFE6E6E6)),
                    itemBuilder: (context, index) {
                      final bank = banks[index];

                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          bank,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          setState(() => selectedBank = bank);
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
}

class _ScheduleSwitchTile extends StatelessWidget {
  const _ScheduleSwitchTile({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Set schedule for this transaction',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Transform.scale(
          scale: 0.78,
          child: Switch(
            value: enabled,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF15213A),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE1E6EC),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

class _SourceAccountField extends StatelessWidget {
  const _SourceAccountField();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'OCTO Pay (*****6147)',
        style: TextStyle(
          color: AppColors.text,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label, required this.child});

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
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        child,
      ],
    );
  }
}

class _TapField extends StatelessWidget {
  const _TapField({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
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
