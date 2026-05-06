import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder_page.dart';

class TransferPage extends StatelessWidget {
  const TransferPage({super.key});

  static const String routeName = '/transfer';

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Transfer',
      message: 'Halaman placeholder untuk fitur Transfer.',
    );
  }
}
