import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../app_state.dart';
import '../theme.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  bool? _fallbackAccessible;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return LoadingOverlay(
          isLoading: appState.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Other Methods'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFallbackSection(),
                  const SizedBox(height: 16),
                  if (Platform.isIOS) _buildIOSSection(),
                  if (Platform.isAndroid) _buildAndroidSection(),
                  const SizedBox(height: 16),
                  _buildSyncSection(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackSection() {
    return SectionCard(
      title: 'Fallback File',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: _checkFallbackFile,
            child: const Text('Check Fallback Accessibility'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Accessible:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 12),
              _buildAccessibilityIndicator(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityIndicator() {
    Color color;
    IconData icon;
    String text;

    if (_fallbackAccessible == null) {
      color = Colors.grey;
      icon = Icons.help_outline;
      text = 'Unknown';
    } else if (_fallbackAccessible!) {
      color = AppTheme.successColor;
      icon = Icons.check_circle;
      text = 'Accessible';
    } else {
      color = AppTheme.errorColor;
      icon = Icons.cancel;
      text = 'Not accessible';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIOSSection() {
    return SectionCard(
      title: 'iOS Only',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _collectAdvertisingId,
            icon: const Icon(Icons.ads_click),
            label: const Text('Collect Advertising ID'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _collectAppleSearchAdsAttribution,
            icon: const Icon(Icons.search),
            label: const Text('Collect Apple Search Ads Attribution'),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _presentCodeRedemptionSheet,
            icon: const Icon(Icons.card_giftcard),
            label: const Text('Present Code Redemption Sheet'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _syncStoreKit2Purchases,
            icon: const Icon(Icons.sync),
            label: const Text('Sync StoreKit 2 Purchases'),
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidSection() {
    return SectionCard(
      title: 'Android Only',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _syncPurchases,
            icon: const Icon(Icons.sync),
            label: const Text('Sync Purchases'),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncSection() {
    return SectionCard(
      title: 'Sync',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: _syncHistoricalData,
            icon: const Icon(Icons.history),
            label: const Text('Sync Historical Data'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkFallbackFile() async {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.setLoading(true);

    try {
      debugPrint('🔄 [Qonversion] Checking fallback file accessibility...');
      final accessible = await Qonversion.getSharedInstance().isFallbackFileAccessible();
      debugPrint('✅ [Qonversion] Fallback accessible: $accessible');
      setState(() => _fallbackAccessible = accessible);
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed to check: $e');
      _showError('Failed to check: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  void _collectAdvertisingId() {
    try {
      debugPrint('🔄 [Qonversion] Collecting advertising ID...');
      Qonversion.getSharedInstance().collectAdvertisingId();
      debugPrint('✅ [Qonversion] Advertising ID collected');
      _showSuccess('Advertising ID collected!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed: $e');
      _showError('Failed: $e');
    }
  }

  void _collectAppleSearchAdsAttribution() {
    try {
      debugPrint('🔄 [Qonversion] Collecting Apple Search Ads attribution...');
      Qonversion.getSharedInstance().collectAppleSearchAdsAttribution();
      debugPrint('✅ [Qonversion] Apple Search Ads attribution collected');
      _showSuccess('Apple Search Ads attribution collected!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed: $e');
      _showError('Failed: $e');
    }
  }

  void _presentCodeRedemptionSheet() {
    try {
      debugPrint('🔄 [Qonversion] Presenting code redemption sheet...');
      Qonversion.getSharedInstance().presentCodeRedemptionSheet();
      debugPrint('✅ [Qonversion] Code redemption sheet presented');
      _showSuccess('Code redemption sheet presented!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed: $e');
      _showError('Failed: $e');
    }
  }

  void _syncStoreKit2Purchases() {
    try {
      debugPrint('🔄 [Qonversion] Syncing StoreKit 2 purchases...');
      Qonversion.getSharedInstance().syncStoreKit2Purchases();
      debugPrint('✅ [Qonversion] StoreKit 2 purchases synced');
      _showSuccess('StoreKit 2 purchases synced!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed: $e');
      _showError('Failed: $e');
    }
  }

  void _syncPurchases() {
    try {
      debugPrint('🔄 [Qonversion] Syncing purchases...');
      Qonversion.getSharedInstance().syncPurchases();
      debugPrint('✅ [Qonversion] Purchases synced');
      _showSuccess('Purchases synced!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed: $e');
      _showError('Failed: $e');
    }
  }

  void _syncHistoricalData() {
    try {
      debugPrint('🔄 [Qonversion] Syncing historical data...');
      Qonversion.getSharedInstance().syncHistoricalData();
      debugPrint('✅ [Qonversion] Historical data synced');
      _showSuccess('Historical data synced!');
    } catch (e) {
      debugPrint('❌ [Qonversion] Failed: $e');
      _showError('Failed: $e');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.successColor),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppTheme.errorColor),
    );
  }
}
