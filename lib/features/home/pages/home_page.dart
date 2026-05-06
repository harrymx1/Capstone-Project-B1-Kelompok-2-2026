import 'package:flutter/material.dart';

import '../../../core/app_colors.dart';
import 'bills_top_up_page.dart';
import 'cardless_page.dart';
import 'investment_page.dart';
import 'more_services_page.dart';
import 'transfer_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const _HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _BalanceCard(),
                    const SizedBox(height: 26),
                    const _ShortcutSection(),
                    const SizedBox(height: 18),
                    _SectionTitle(
                      title: 'e-Wallet',
                      actionLabel: 'Lihat Semua',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    const _WalletRow(),
                    const SizedBox(height: 18),
                    const Text(
                      'News & Promotion',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1B2435),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _PromoTabs(),
                    const SizedBox(height: 16),
                    const _PromoBanner(),
                  ],
                ),
              ),
            ),
            const _HomeBottomNav(),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.primary,
      child: const Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Good Morning\n',
                children: [
                  TextSpan(
                    text: 'David!',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
          Icon(Icons.notifications_none_rounded, color: Colors.white, size: 28),
          SizedBox(width: 14),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(Icons.person_outline_rounded, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 208,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Rekening Utama\n800123456789',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.65,
                  ),
                ),
              ),
              // TODO: replace with actual asset
              Icon(
                Icons.visibility_off_outlined,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
          SizedBox(height: 18),
          Text(
            'Saldo Tersedia',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            'Rp •••••••',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutSection extends StatelessWidget {
  const _ShortcutSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            _Pill(label: 'For You', selected: true),
            SizedBox(width: 6),
            _Pill(label: 'Transaction'),
            SizedBox(width: 6),
            _Pill(label: 'Products'),
            SizedBox(width: 6),
            _Pill(label: 'News'),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 18,
          childAspectRatio: 0.82,
          children: const [
            _ShortcutItem(
              icon: Icons.send_outlined,
              label: 'Transfer',
              routeName: TransferPage.routeName,
            ),
            _ShortcutItem(
              icon: Icons.receipt_long_outlined,
              label: 'Bills &\nTop Up',
              routeName: BillsTopUpPage.routeName,
            ),
            _ShortcutItem(
              icon: Icons.money_outlined,
              label: 'Cardless',
              routeName: CardlessPage.routeName,
            ),
            SizedBox.shrink(),
            _ShortcutItem(
              icon: Icons.account_balance_wallet_outlined,
              label: 'Investment',
              routeName: InvestmentPage.routeName,
            ),
            _ShortcutItem(
              icon: Icons.more_horiz_rounded,
              label: 'Lainnya',
              routeName: MoreServicesPage.routeName,
              muted: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 43,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : const Color(0xFFCACACA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ShortcutItem extends StatelessWidget {
  const _ShortcutItem({
    required this.icon,
    required this.label,
    required this.routeName,
    this.muted = false,
  });

  final IconData icon;
  final String label;
  final String routeName;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label.replaceAll('\n', ' '),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, routeName),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: muted ? const Color(0xFF737B8C) : AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 8,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              // TODO: replace with actual asset
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1B2435),
                fontSize: 12,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B2435),
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionLabel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletRow extends StatelessWidget {
  const _WalletRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _WalletCard(
            title: 'OCTO Pay',
            subtitle: 'Rp •••••••',
            leadingIcon: Icons.account_balance_wallet,
            trailing: Icon(Icons.add, color: AppColors.primary, size: 18),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _WalletCard(
            title: 'gopay',
            subtitle: 'Connect',
            leadingIcon: Icons.wallet,
            actionStyle: true,
          ),
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.trailing,
    this.actionStyle = false,
  });

  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final Widget? trailing;
  final bool actionStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // TODO: replace with actual asset
              Icon(leadingIcon, color: AppColors.primary, size: 18),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: title == 'gopay' ? Colors.black : AppColors.primary,
                    fontSize: title == 'gopay' ? 21 : 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const Spacer(),
          if (actionStyle)
            Container(
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
            Row(
              children: [
                const Icon(Icons.visibility_off_outlined, size: 17),
                const SizedBox(width: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PromoTabs extends StatelessWidget {
  const _PromoTabs();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _Pill(label: 'All', selected: true),
        SizedBox(width: 6),
        _Pill(label: 'Promo'),
        SizedBox(width: 6),
        _Pill(label: 'News'),
        Spacer(),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 72,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "From Payments to Travel,\nMade Easier with OCTO's New Features",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 12),
                      _PromoLine('Easy Way to Verify Transactions'),
                      _PromoLine('Set Your Credit Card Transaction Types'),
                      _PromoLine('Tukar PoinXtra ke AsiaMiles'),
                      _PromoLine('Jajan di Korea, Bayarnya Pakai Rupiah'),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    // TODO: replace with actual asset
                    child: const Icon(
                      Icons.phone_iphone_rounded,
                      color: Colors.white,
                      size: 74,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 88,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Center(
              child: Text(
                'GET\nPay\non OCTO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PromoLine extends StatelessWidget {
  const _PromoLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _HomeBottomNav extends StatelessWidget {
  const _HomeBottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE7E7E7))),
        boxShadow: [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
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
