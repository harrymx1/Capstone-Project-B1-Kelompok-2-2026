import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder_page.dart';

class InvestmentPage extends StatelessWidget {
  const InvestmentPage({super.key});

  static const String routeName = '/investment';

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Investment',
      message: 'Halaman placeholder untuk fitur Investment.',
    );
  }
}
