import 'package:flutter/material.dart';

class BillsTopUpPage extends StatelessWidget {
  const BillsTopUpPage({super.key});

  static const String routeName = '/bills-top-up';

  @override
  Widget build(BuildContext context) {
    return const _FeaturePlaceholderScaffold(
      title: 'Bills & Top Up',
      message: 'Halaman placeholder untuk fitur Bills & Top Up.',
    );
  }
}

class _FeaturePlaceholderScaffold extends StatelessWidget {
  const _FeaturePlaceholderScaffold({
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
