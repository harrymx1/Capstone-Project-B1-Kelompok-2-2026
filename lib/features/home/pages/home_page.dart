import 'package:flutter/material.dart';

import '../../../core/services/home_service.dart';
import '../../../core/services/user_session.dart';
import '../../../core/theme/app_colors.dart';
import '../../bills/pages/bills_top_up_page.dart';
import '../../investment/pages/investment_page.dart';
import '../../others/pages/more_services_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../transfer/pages/transfer_page.dart';
import '../../wealth/pages/wealth_page.dart';
import '../../withdrawal/pages/cardless_page.dart';
import 'bottom_nav_placeholder_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.user});

  static const String routeName = '/home';

  final Map<String, dynamic>? user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _homeData;
  bool _loading = true;
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoaded) {
      _hasLoaded = true;
      _loadHome();
    }
  }

  Future<void> _loadHome() async {
    final routeUser =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final currentUser = widget.user ?? routeUser ?? UserSession.user;

    if (currentUser == null) {
      setState(() {
        _loading = false;
      });
      return;
    }

    UserSession.setUser(currentUser);

    final userId = currentUser['user_id'];

    try {
      final result = await HomeService.getHomeData(userId);

      if (!mounted) return;

      setState(() {
        _homeData = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeUser =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final currentUser = widget.user ?? routeUser ?? UserSession.user;

    final recommendation =
        _homeData?['recommendation'] as Map<String, dynamic>?;

    final promoCatalog = (_homeData?['promo_catalog'] as List<dynamic>?) ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _HomeHeader(user: currentUser),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _BalanceCard(),
                          const SizedBox(height: 20),

                          if (recommendation != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F6FA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recommendation['primary_hero'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    recommendation['suggested_action'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    recommendation['insight'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),
                          const _ShortcutSection(),
                          if (_loading)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Center(child: CircularProgressIndicator()),
                            ),

                          if (!_loading && recommendation != null)
                            _RecommendationCard(
                              title: recommendation['primary_hero'] ?? '',
                              action: recommendation['suggested_action'] ?? '',
                              insight: recommendation['insight'] ?? '',
                            ),
                          const SizedBox(height: 18),

                          _SectionTitle(
                            title: 'e-Wallet',
                            actionLabel: 'Lihat Semua',
                            onTap: () {},
                          ),

                          const SizedBox(height: 12),
                          const _WalletRow(),
                          const SizedBox(height: 20),

                          const Text(
                            'News & Promotion',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B2435),
                            ),
                          ),

                          const SizedBox(height: 12),

                          if (promoCatalog.isEmpty)
                            const Text(
                              'Belum ada promo tersedia.',
                              style: TextStyle(color: Colors.black54),
                            )
                          else
                            Column(
                              children: promoCatalog.map((promo) {
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        promo['item_name'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        promo['description'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
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
  const _HomeHeader({this.user});

  final Map<String, dynamic>? user;

  @override
  Widget build(BuildContext context) {
    final userName = user?['nama'] ?? UserSession.userName;
    final persona =
        user?['persona'] ?? user?['segmen_persona'] ?? UserSession.persona;

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: AppColors.primary,
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Good Morning\n',
                children: [
                  TextSpan(
                    text: '$userName${persona.isNotEmpty ? ' ($persona)' : ''}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
          const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 14),
          InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => Navigator.pushNamed(context, ProfilePage.routeName),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
              ),
            ),
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

// ignore: unused_element
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

// ignore: unused_element
class _PromoBanner extends StatelessWidget {
  const _PromoBanner({
    required this.recommendation,
    required this.promoCatalog,
  });

  final Map<String, dynamic>? recommendation;
  final List<dynamic> promoCatalog;

  @override
  Widget build(BuildContext context) {
    final hero = recommendation?['primary_hero'] ?? 'Promo Personal Untuk Kamu';

    final action = recommendation?['suggested_action'] ?? 'Cek promo terbaru';

    final insight =
        recommendation?['insight'] ??
        'Nikmati layanan yang sesuai kebutuhanmu.';

    final promoItems = promoCatalog.take(4).toList();

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
                Expanded(
                  flex: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hero,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        action,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        insight,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (final item in promoItems)
                        _PromoLine(item['item_name'] ?? ''),
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
                    child: const Icon(
                      Icons.local_offer_outlined,
                      color: Colors.white,
                      size: 70,
                    ),
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

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({
    required this.title,
    required this.action,
    required this.insight,
  });

  final String title;
  final String action;
  final String insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended For You',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            action,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(insight, style: const TextStyle(fontSize: 12, height: 1.4)),
        ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const _NavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            selected: true,
          ),
          _NavItem(
            icon: Icons.credit_card_rounded,
            label: 'My Account',
            onTap: () => Navigator.pushNamed(
              context,
              BottomNavPlaceholderPage.routeName,
              arguments: 'My Account',
            ),
          ),
          _NavItem(
            icon: Icons.qr_code_scanner_rounded,
            label: 'QRIS',
            blue: true,
            onTap: () => Navigator.pushNamed(
              context,
              BottomNavPlaceholderPage.routeName,
              arguments: 'QRIS',
            ),
          ),
          _NavItem(
            icon: Icons.storage_rounded,
            label: 'Wealth',
            onTap: () => Navigator.pushNamed(context, WealthPage.routeName),
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => Navigator.pushNamed(
              context,
              BottomNavPlaceholderPage.routeName,
              arguments: 'Settings',
            ),
          ),
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool blue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? AppColors.primary
        : blue
        ? const Color(0xFF008BFF)
        : const Color(0xFF898989);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
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
      ),
    );
  }
}
