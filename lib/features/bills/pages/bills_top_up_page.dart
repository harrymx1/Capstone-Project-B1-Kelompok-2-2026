import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'bills_menu_placeholder_page.dart';
import 'electricity_bill_page.dart';
import 'e_wallet_top_up_page.dart';

class BillsTopUpPage extends StatelessWidget {
  const BillsTopUpPage({super.key});

  static const String routeName = '/bills-top-up';

  static const eWallets = [
    'Flazz BCA',
    'BNI TapCash',
    'ShopeePay',
    'GoPay',
    'GoPay Driver',
    'OVO',
    'DANA',
    'DOKU Wallet',
    'iSaku',
    'LinkAja',
    'AstraPay',
    'MOTION PAY',
    'M-Bayar',
    'OTTOCASH',
    'Gudang Voucher',
    'iPaymu Top Up',
    'Neo Pay',
  ];

  static const electricityOptions = [
    'Electricity Token',
    'Electricity Bill',
    'Non-Electricity Bill',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _BillsHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 34, 24, 24),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search VA number or company',
                        prefixIcon: const Icon(Icons.search_rounded, size: 22),
                        hintStyle: const TextStyle(
                          color: Color(0xFFC4C4C4),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        enabledBorder: _outlineBorder(AppColors.border),
                        focusedBorder: _outlineBorder(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 72),
                    GridView.count(
                      crossAxisCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 22,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.76,
                      children: [
                        _BillMenuItem(
                          icon: Icons.credit_card_rounded,
                          label: 'e-Wallet',
                          onTap: () => _showEWalletPicker(context),
                        ),
                        _BillMenuItem(
                          icon: Icons.phone_android_rounded,
                          label: 'Phone/Mobile',
                          onTap: () =>
                              _openPlaceholder(context, 'Phone/Mobile'),
                        ),
                        _BillMenuItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'Tax',
                          onTap: () => _openPlaceholder(context, 'Tax'),
                        ),
                        _BillMenuItem(
                          icon: Icons.water_drop_outlined,
                          label: 'PAM/PDAM',
                          onTap: () => _openPlaceholder(context, 'PAM/PDAM'),
                        ),
                        _BillMenuItem(
                          icon: Icons.shopping_cart_outlined,
                          label: 'e-Commerce\n& Payment',
                          onTap: () =>
                              _openPlaceholder(context, 'e-Commerce & Payment'),
                        ),
                        _BillMenuItem(
                          icon: Icons.bolt_rounded,
                          label: 'Electricity',
                          onTap: () => _showElectricityPicker(context),
                        ),
                        _BillMenuItem(
                          icon: Icons.payment_rounded,
                          label: 'Credit Card',
                          onTap: () => _openPlaceholder(context, 'Credit Card'),
                        ),
                        _BillMenuItem(
                          icon: Icons.request_quote_outlined,
                          label: 'Virtual\nAccount',
                          onTap: () =>
                              _openPlaceholder(context, 'Virtual Account'),
                        ),
                        _BillMenuItem(
                          icon: Icons.wifi_rounded,
                          label: 'Internet/\nCable TV',
                          onTap: () =>
                              _openPlaceholder(context, 'Internet/Cable TV'),
                        ),
                        _BillMenuItem(
                          icon: Icons.health_and_safety_outlined,
                          label: 'Insurance',
                          onTap: () => _openPlaceholder(context, 'Insurance'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 44),
                    const _PromoBanner(),
                    const SizedBox(height: 56),
                    const Text(
                      'Your saved favorites',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Transactions are always faster when\nadded to favorites. Save your transaction\nto see them here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPlaceholder(BuildContext context, String title) {
    Navigator.pushNamed(
      context,
      BillsMenuPlaceholderPage.routeName,
      arguments: title,
    );
  }

  void _showEWalletPicker(BuildContext context) {
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
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.78,
            child: Column(
              children: [
                const SizedBox(height: 28),
                const Text(
                  'Select Bank Destination',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 44, 24, 18),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Select destination bank',
                      prefixIcon: const Icon(Icons.search_rounded, size: 22),
                      hintStyle: const TextStyle(
                        color: Color(0xFFC4C4C4),
                        fontSize: 14,
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
                    itemCount: eWallets.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: Color(0xFFE6E6E6)),
                    itemBuilder: (context, index) {
                      final wallet = eWallets[index];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          wallet,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            pageContext,
                            EWalletTopUpPage.routeName,
                            arguments: wallet,
                          );
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

  void _showElectricityPicker(BuildContext context) {
    final pageContext = context;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Electricity',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 28),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: electricityOptions.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: Color(0xFFE6E6E6)),
                  itemBuilder: (context, index) {
                    final option = electricityOptions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        option,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          pageContext,
                          ElectricityBillPage.routeName,
                          arguments: option,
                        );
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

class _BillsHeader extends StatelessWidget {
  const _BillsHeader();

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
          const Expanded(
            child: Text(
              'Bills & Top Up',
              textAlign: TextAlign.center,
              style: TextStyle(
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

class _BillMenuItem extends StatelessWidget {
  const _BillMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          // TODO: replace with actual asset
          Icon(icon, color: AppColors.primary, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 10,
              height: 1.15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 88,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFD71920),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'TOP UP & PAY BILLS ON OCTO\nSAVE UP TO HUNDREDS OF\nTHOUSAND RUPIAH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                // TODO: replace with actual asset
                const Icon(
                  Icons.phone_android_rounded,
                  color: Colors.white,
                  size: 58,
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Container(
            width: 90,
            decoration: BoxDecoration(
              color: const Color(0xFFE87445),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long_rounded, color: Colors.white),
          ),
        ],
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
