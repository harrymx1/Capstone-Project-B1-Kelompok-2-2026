import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MySchedulePage extends StatelessWidget {
  const MySchedulePage({super.key});

  static const String routeName = '/my-schedule';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Schedule',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: const SizedBox.expand(),
    );
  }
}
