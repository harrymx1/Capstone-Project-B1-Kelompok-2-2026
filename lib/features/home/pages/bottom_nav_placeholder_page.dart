import 'package:flutter/material.dart';

class BottomNavPlaceholderPage extends StatelessWidget {
  const BottomNavPlaceholderPage({super.key, required this.title});

  static const String routeName = '/bottom-nav-placeholder';

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
