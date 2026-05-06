import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/transfer_draft.dart';
import 'transfer_success_page.dart';

class ConfirmTransferPage extends StatefulWidget {
  const ConfirmTransferPage({super.key, required this.draft});

  static const String routeName = '/confirm-transfer';

  final TransferDraft draft;

  @override
  State<ConfirmTransferPage> createState() => _ConfirmTransferPageState();
}

class _ConfirmTransferPageState extends State<ConfirmTransferPage> {
  late final TextEditingController notesController;
  String transferMethod = 'BI-Fast';

  @override
  void initState() {
    super.initState();
    transferMethod = widget.draft.transferMethod;
    notesController = TextEditingController(text: widget.draft.notes);
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updatedDraft = widget.draft.copyWith(
      transferMethod: transferMethod,
      notes: notesController.text,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Confirm'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirm transaction information',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Transfer from',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _AccountCard(
                      title: 'OCTO Pay (*****6147)',
                      subtitle: 'David',
                      amount: 'Balance\nRp 67.670',
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Transfer to',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _SummaryField(
                      label: 'Bank name',
                      value: widget.draft.destinationBank,
                    ),
                    const SizedBox(height: 12),
                    _SummaryField(
                      label: 'Recipient Account',
                      value: widget.draft.accountNumber,
                      suffixIcon: Icons.favorite_border_rounded,
                    ),
                    const SizedBox(height: 12),
                    _SummaryField(label: 'Amount', value: widget.draft.amount),
                    const SizedBox(height: 12),
                    _SummaryField(
                      label: 'Message (Optional)',
                      value: widget.draft.message,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Transfer Method',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: transferMethod,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        enabledBorder: _outlineBorder(AppColors.border),
                        focusedBorder: _outlineBorder(AppColors.primary),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'BI-Fast',
                          child: Text('BI-Fast'),
                        ),
                        DropdownMenuItem(
                          value: 'Online',
                          child: Text('Online'),
                        ),
                        DropdownMenuItem(value: 'SKN', child: Text('SKN')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => transferMethod = value);
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text.rich(
                        TextSpan(
                          text: 'Admin Fee   ',
                          children: [
                            TextSpan(
                              text: 'IDR 2.500',
                              style: TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Notes',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
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
                label: 'Confirm',
                onPressed: () => _showPinDialog(updatedDraft),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPinDialog(TransferDraft draft) {
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
                const SizedBox(height: 28),
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
                const SizedBox(height: 14),
                _PrimaryButton(
                  label: 'Continue',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      this.context,
                      TransferSuccessPage.routeName,
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

class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final String title;
  final String subtitle;
  final String amount;

  @override
  Widget build(BuildContext context) {
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
          // TODO: replace with actual asset
          const Icon(Icons.credit_card_rounded, color: Colors.white, size: 42),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
                const Spacer(),
                Text(
                  amount,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
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

class _SummaryField extends StatelessWidget {
  const _SummaryField({
    required this.label,
    required this.value,
    this.suffixIcon,
  });

  final String label;
  final String value;
  final IconData? suffixIcon;

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
        Container(
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
                  value,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (suffixIcon != null)
                Icon(suffixIcon, color: AppColors.textMuted),
            ],
          ),
        ),
      ],
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
