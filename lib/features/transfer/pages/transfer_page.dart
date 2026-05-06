import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import 'transfer_form_page.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});

  static const String routeName = '/transfer';

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  int selectedTab = 0;

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            child: Row(
              children: [
                Expanded(
                  child: _TransferTab(
                    icon: Icons.receipt_long_outlined,
                    label: 'Recent Transaction',
                    selected: selectedTab == 0,
                    onTap: () => setState(() => selectedTab = 0),
                  ),
                ),
                Expanded(
                  child: _TransferTab(
                    icon: Icons.favorite_border_rounded,
                    label: 'Favorites',
                    selected: selectedTab == 1,
                    onTap: () => setState(() => selectedTab = 1),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search destination account',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                hintStyle: const TextStyle(
                  color: Color(0xFFC4C4C4),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          Expanded(
            child: _EmptyTransferState(
              title: selectedTab == 0
                  ? 'No recent transactions'
                  : 'You have no favorites',
              subtitle: selectedTab == 0
                  ? null
                  : 'Transact now to add favorites',
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, TransferFormPage.routeName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'New Transfer',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const _TransferBottomNav(),
        ],
      ),
    );
  }
}

class _TransferTab extends StatelessWidget {
  const _TransferTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : const Color(0xFFD4D4D4);

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 3,
            width: selected ? 126 : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTransferState extends StatelessWidget {
  const _EmptyTransferState({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // TODO: replace with actual asset
        Icon(
          Icons.receipt_long_rounded,
          size: 112,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 14),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _TransferBottomNav extends StatelessWidget {
  const _TransferBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7E7E7))),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home', selected: true),
          _NavItem(icon: Icons.credit_card_rounded, label: 'My Account'),
          _NavItem(
            icon: Icons.qr_code_scanner_rounded,
            label: 'QRIS',
            blue: true,
          ),
          _NavItem(icon: Icons.storage_rounded, label: 'Wealth'),
          _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.blue = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool blue;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.primary
        : blue
        ? const Color(0xFF008BFF)
        : const Color(0xFF898989);

    return SizedBox(
      width: 68,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: replace with actual asset
          Icon(icon, color: color, size: blue ? 30 : 27),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
