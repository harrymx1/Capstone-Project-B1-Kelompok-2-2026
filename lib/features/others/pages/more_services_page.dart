import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder_page.dart';

class MoreServicesPage extends StatelessWidget {
  const MoreServicesPage({super.key});

  static const String routeName = '/more-services';

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Lainnya',
      message: 'Halaman placeholder untuk fitur Lainnya.',
    );
  }
}
