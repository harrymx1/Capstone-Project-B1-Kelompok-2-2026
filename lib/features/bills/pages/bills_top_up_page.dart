import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder_page.dart';

class BillsTopUpPage extends StatelessWidget {
  const BillsTopUpPage({super.key});

  static const String routeName = '/bills-top-up';

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Bills & Top Up',
      message: 'Halaman placeholder untuk fitur Bills & Top Up.',
    );
  }
}
