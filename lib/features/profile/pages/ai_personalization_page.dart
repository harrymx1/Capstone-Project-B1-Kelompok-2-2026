import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/consent_service.dart';
import '../../../core/services/feature_tracking_service.dart';
import '../../../core/services/user_session.dart';
import '../../../core/theme/app_colors.dart';

class AiPersonalizationPage extends StatefulWidget {
  const AiPersonalizationPage({super.key});

  static const String routeName = '/ai-personalization';

  @override
  State<AiPersonalizationPage> createState() => _AiPersonalizationPageState();
}

class _AiPersonalizationPageState extends State<AiPersonalizationPage> {
  late bool _consentEnabled;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _consentEnabled = _readConsent(UserSession.user?['consent_ai']);
  }

  bool _readConsent(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) return value == '1' || value.toLowerCase() == 'true';
    return false;
  }

  Future<void> _updateConsent(bool value) async {
    final user = UserSession.user;
    final userId = user?['user_id']?.toString();

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User tidak ditemukan')));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await ConsentService.updateConsent(userId: userId, consentStatus: value);

      final updatedUser = {...?user, 'consent_ai': value ? 1 : 0};
      UserSession.setUser(updatedUser);

      unawaited(
        FeatureTrackingService.trackConsentUpdate(
          userId: userId,
          consentStatus: value,
        ),
      );

      if (!mounted) return;

      setState(() {
        _consentEnabled = value;
        _loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan privasi berhasil diperbarui')),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'AI Personalization',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Personalization',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Aktifkan personalisasi untuk mendapatkan rekomendasi promo dan fitur yang sesuai dengan aktivitas Anda.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Izinkan rekomendasi personal',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Dapat diubah kapan saja.',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_loading)
                    const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  else
                    Switch(
                      value: _consentEnabled,
                      activeThumbColor: AppColors.primary,
                      onChanged: _updateConsent,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
