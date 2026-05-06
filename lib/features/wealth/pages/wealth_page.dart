import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class WealthPage extends StatefulWidget {
  const WealthPage({super.key});

  static const String routeName = '/wealth';

  @override
  State<WealthPage> createState() => _WealthPageState();
}

class _WealthPageState extends State<WealthPage> {
  int selectedTab = 0;

  static const tabs = ['Assets', 'Money In', 'Money Out'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 230,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 16,
                    top: 26,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0, 0.38),
                    child: Text(
                      'Wealth',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  return Expanded(
                    child: _WealthTab(
                      label: tabs[index],
                      selected: selectedTab == index,
                      onTap: () => setState(() => selectedTab = index),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: const [_AssetsTab(), _MoneyInTab(), _MoneyOutTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WealthTab extends StatelessWidget {
  const _WealthTab({
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
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primary : const Color(0xFFC8C8C8),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 4,
            width: selected ? 78 : 0,
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

class _AssetsTab extends StatelessWidget {
  const _AssetsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
      child: Column(
        children: [
          const _WealthAccountCard(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Rp 67.670',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(height: 130, child: _SimpleBarChart()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WealthAccountCard extends StatelessWidget {
  const _WealthAccountCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 134,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: replace with actual asset
          Icon(Icons.credit_card_rounded, color: Colors.white, size: 68),
          Spacer(),
          Text(
            'OCTO Pay (*****6147)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text('David', style: TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  const _SimpleBarChart();

  @override
  Widget build(BuildContext context) {
    final values = [48.0, 70.0, 105.0, 62.0, 42.0, 76.0, 42.0, 64.0];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(child: _ChartGuides()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: values.map((value) {
                  return _ChartBar(height: value);
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: months.map((month) {
            return Text(
              month,
              style: TextStyle(
                color: month == 'Apr'
                    ? AppColors.primary
                    : const Color(0xFFC8C8C8),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ChartGuides extends StatelessWidget {
  const _ChartGuides();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (_) => Container(height: 1, color: const Color(0xFFECECF2)),
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 12,
      height: 112,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 5,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Align(
            alignment: Alignment.center,
            child: FractionallySizedBox(
              heightFactor: 0.42,
              widthFactor: 1,
              child: Container(color: const Color(0xFFFF4B7E)),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoneyInTab extends StatelessWidget {
  const _MoneyInTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 58, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Today'),
          _TransactionRow(
            icon: Icons.receipt_long_rounded,
            title: 'Income : Bayu\ntransfers via OCTO',
            amount: '+ Rp 32.000',
          ),
          SizedBox(height: 22),
          _SectionLabel('Yesterday'),
        ],
      ),
    );
  }
}

class _MoneyOutTab extends StatelessWidget {
  const _MoneyOutTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 58, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('Today'),
          _TransactionRow(
            icon: Icons.water_drop_rounded,
            title: 'Water Bill',
            amount: '- Rp 250.000',
          ),
          SizedBox(height: 22),
          _SectionLabel('Yesterday'),
          _TransactionRow(
            icon: Icons.request_quote_rounded,
            title: 'Top Up Gopay 0852\nxxx47',
            amount: '- Rp 67.000',
          ),
          _TransactionRow(
            icon: Icons.bolt_rounded,
            title: 'Electric Bill',
            amount: '- Rp 100.000',
          ),
          _TransactionRow(
            icon: Icons.receipt_long_rounded,
            title: 'Transfer 08xxx47 via\nOCTO',
            amount: '- Rp 50.000',
          ),
          _TransactionRow(
            icon: Icons.event_note_rounded,
            title: 'QRIS Creative Land\nCanteen',
            amount: '- Rp 15.000',
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.icon,
    required this.title,
    required this.amount,
  });

  final IconData icon;
  final String title;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8E8E8))),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(9),
            ),
            // TODO: replace with actual asset
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 17,
                height: 1.25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            amount,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
