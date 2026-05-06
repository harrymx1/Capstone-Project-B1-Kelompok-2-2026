import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder_page.dart';

class CardlessPage extends StatelessWidget {
  const CardlessPage({super.key});

  static const String routeName = '/cardless';

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholderPage(
      title: 'Cardless',
      message: 'Halaman placeholder untuk fitur Cardless.',
    );
  }
}
