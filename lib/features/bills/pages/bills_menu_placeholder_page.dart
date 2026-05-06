import 'package:flutter/material.dart';

class BillsMenuPlaceholderPage extends StatelessWidget {
  const BillsMenuPlaceholderPage({super.key, required this.title});

  static const String routeName = '/bills-menu-placeholder';

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
