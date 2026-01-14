import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../app_state.dart';
import '../theme.dart';

/// Sample PurchaseDelegate implementation for testing purposes.
/// 
/// In a real app, you would implement your own purchase system here
/// (e.g., RevenueCat, custom backend, StoreKit directly, etc.).
/// 
/// For this sample, we use Qonversion SDK to perform purchases,
/// just to demonstrate how the delegate works.
class SamplePurchaseDelegate implements NoCodesPurchaseDelegate {
  final void Function(String message) onEvent;
  
  SamplePurchaseDelegate({required this.onEvent});
  
  @override
  Future<void> purchase(QProduct product) async {
    onEvent('🛒 [PurchaseDelegate] purchase() called for: ${product.qonversionId}');
    debugPrint('🛒 [PurchaseDelegate] purchase() called for product: ${product.qonversionId}');
    debugPrint('   Store ID: ${product.storeId}');
    debugPrint('   Type: ${product.type}');
    debugPrint('   Price: ${product.prettyPrice}');
    
    try {
      // For testing purposes, we use Qonversion SDK here.
      // In a real app, you would use your own purchase system.
      onEvent('🔄 [PurchaseDelegate] Performing purchase...');
      final result = await Qonversion.getSharedInstance().purchaseWithResult(product);
      
      if (result.status == QPurchaseResultStatus.success) {
        onEvent('✅ [PurchaseDelegate] Purchase successful!');
        debugPrint('✅ [PurchaseDelegate] Purchase successful');
      } else if (result.status == QPurchaseResultStatus.userCanceled) {
        onEvent('⚠️ [PurchaseDelegate] Purchase canceled by user');
        debugPrint('⚠️ [PurchaseDelegate] Purchase canceled');
        throw Exception('Purchase was canceled by user');
      } else if (result.status == QPurchaseResultStatus.pending) {
        onEvent('⏳ [PurchaseDelegate] Purchase pending');
        debugPrint('⏳ [PurchaseDelegate] Purchase pending');
      } else {
        final errorMessage = result.error?.message ?? 'Unknown error';
        onEvent('❌ [PurchaseDelegate] Purchase failed: $errorMessage');
        debugPrint('❌ [PurchaseDelegate] Purchase failed: $errorMessage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      onEvent('❌ [PurchaseDelegate] Purchase error: $e');
      debugPrint('❌ [PurchaseDelegate] Purchase error: $e');
      rethrow;
    }
  }
  
  @override
  Future<void> restore() async {
    onEvent('🔄 [PurchaseDelegate] restore() called');
    debugPrint('🔄 [PurchaseDelegate] restore() called');
    
    try {
      // For testing purposes, we use Qonversion SDK here.
      // In a real app, you would use your own restore logic.
      onEvent('🔄 [PurchaseDelegate] Performing restore...');
      final entitlements = await Qonversion.getSharedInstance().restore();
      
      onEvent('✅ [PurchaseDelegate] Restore successful! Entitlements: ${entitlements.length}');
      debugPrint('✅ [PurchaseDelegate] Restore successful. Entitlements count: ${entitlements.length}');
    } catch (e) {
      onEvent('❌ [PurchaseDelegate] Restore error: $e');
      debugPrint('❌ [PurchaseDelegate] Restore error: $e');
      rethrow;
    }
  }
}

class NoCodesScreen extends StatefulWidget {
  const NoCodesScreen({super.key});

  @override
  State<NoCodesScreen> createState() => _NoCodesScreenState();
}

class _NoCodesScreenState extends State<NoCodesScreen> {
  final _contextKeyController = TextEditingController(text: 'kamo_test');
  final _localeController = TextEditingController();
  
  NoCodesPresentationStyle _presentationStyle = NoCodesPresentationStyle.fullScreen;
  bool _animated = true;
  bool _purchaseDelegateEnabled = false;
  SamplePurchaseDelegate? _purchaseDelegate;

  @override
  void dispose() {
    _contextKeyController.dispose();
    _localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('No-Codes'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () {
                  appState.clearNoCodesEvents();
                  _showInfo('Events cleared');
                },
                tooltip: 'Clear events',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildShowScreenSection(),
                const SizedBox(height: 16),
                _buildPurchaseDelegateSection(appState),
                const SizedBox(height: 16),
                _buildPresentationConfigSection(),
                const SizedBox(height: 16),
                _buildLocaleSection(),
                const SizedBox(height: 16),
                _buildActionsSection(),
                const SizedBox(height: 16),
                _buildEventsSection(appState),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShowScreenSection() {
    return SectionCard(
      title: 'Show Screen',
      child: Column(
        children: [
          TextField(
            controller: _contextKeyController,
            decoration: const InputDecoration(
              hintText: 'Enter context key',
              labelText: 'Context Key',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showScreen,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Show No-Code Screen'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseDelegateSection(AppState appState) {
    return SectionCard(
      title: 'Purchase Delegate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _purchaseDelegateEnabled 
                  ? Colors.green.shade50 
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _purchaseDelegateEnabled 
                    ? Colors.green.shade200 
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _purchaseDelegateEnabled 
                      ? Icons.check_circle 
                      : Icons.circle_outlined,
                  color: _purchaseDelegateEnabled 
                      ? Colors.green 
                      : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _purchaseDelegateEnabled 
                            ? 'Custom Purchase Handling ENABLED' 
                            : 'Custom Purchase Handling DISABLED',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _purchaseDelegateEnabled 
                              ? Colors.green.shade700 
                              : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _purchaseDelegateEnabled
                            ? 'Purchases from No-Code screens will be handled by the custom delegate'
                            : 'Purchases from No-Code screens will use default SDK flow',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _purchaseDelegateEnabled ? null : () => _togglePurchaseDelegate(appState),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Enable Custom Purchase Delegate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When enabled, purchase() and restore() calls from No-Code screens '
            'will be logged in the Events section below. Once enabled, delegate stays active.',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresentationConfigSection() {
    return SectionCard(
      title: 'Presentation Config',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Presentation Style',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          ...NoCodesPresentationStyle.values.map((style) => _buildRadioTile(
            title: style.name,
            value: style,
            groupValue: _presentationStyle,
            onChanged: (value) => setState(() => _presentationStyle = value!),
          )),
          
          if (Platform.isIOS) ...[
            const SizedBox(height: 12),
            CheckboxListTile(
              title: const Text('Animated (iOS only)'),
              value: _animated,
              onChanged: (value) => setState(() => _animated = value ?? true),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
          
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _setPresentationConfig,
            child: const Text('Set Presentation Config'),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioTile<T>({
    required String title,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    return RadioListTile<T>(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  Widget _buildLocaleSection() {
    return SectionCard(
      title: 'Locale',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _localeController,
            decoration: const InputDecoration(
              hintText: 'e.g. en, de, fr',
              labelText: 'Locale code',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _setLocale,
            icon: const Icon(Icons.language),
            label: const Text('Set Locale'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _resetLocale,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset to Device Default'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return SectionCard(
      title: 'Actions',
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: _close,
          icon: const Icon(Icons.close),
          label: const Text('Close No-Codes Screen'),
        ),
      ),
    );
  }

  Widget _buildEventsSection(AppState appState) {
    return SectionCard(
      title: 'Events (${appState.noCodesEvents.length})',
      child: appState.noCodesEvents.isEmpty
          ? Text(
              'No events yet. Show a screen to see events.',
              style: TextStyle(color: Colors.grey.shade600),
            )
          : Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: appState.noCodesEvents.length,
                itemBuilder: (context, index) {
                  final event = appState.noCodesEvents[index];
                  // Color-code different event types
                  Color textColor = Colors.grey.shade800;
                  if (event.contains('[PurchaseDelegate]')) {
                    if (event.contains('✅')) {
                      textColor = Colors.green.shade700;
                    } else if (event.contains('❌')) {
                      textColor = Colors.red.shade700;
                    } else if (event.contains('🛒') || event.contains('🔄')) {
                      textColor = Colors.blue.shade700;
                    } else if (event.contains('⚠️')) {
                      textColor = Colors.orange.shade700;
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      event,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: textColor,
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _togglePurchaseDelegate(AppState appState) async {
    // Create and set the purchase delegate
    _purchaseDelegate = SamplePurchaseDelegate(
      onEvent: (message) {
        appState.addNoCodesEvent(message);
      },
    );
    
    try {
      debugPrint('🔄 [NoCodes] Enabling custom purchase delegate...');
      await NoCodes.getSharedInstance().setPurchaseDelegate(_purchaseDelegate!);
      setState(() {
        _purchaseDelegateEnabled = true;
      });
      debugPrint('✅ [NoCodes] Custom purchase delegate enabled');
      appState.addNoCodesEvent('✅ Custom Purchase Delegate ENABLED');
      _showSuccess('Custom purchase handling enabled');
    } catch (e) {
      debugPrint('❌ [NoCodes] Failed to set purchase delegate: $e');
      _showError('Failed to enable purchase delegate: $e');
    }
  }

  void _showScreen() {
    final contextKey = _contextKeyController.text.trim();
    
    try {
      debugPrint('🔄 [NoCodes] Showing screen: $contextKey');
      NoCodes.getSharedInstance().showScreen(contextKey);
      debugPrint('✅ [NoCodes] showScreen called');
    } catch (e) {
      debugPrint('❌ [NoCodes] Failed to show screen: $e');
      _showError('Failed to show screen: $e');
    }
  }

  void _setPresentationConfig() {
    final contextKey = _contextKeyController.text.trim();
    
    try {
      debugPrint('🔄 [NoCodes] Setting presentation config: $_presentationStyle, animated: $_animated');
      final config = NoCodesPresentationConfig(
        presentationStyle: _presentationStyle,
        animated: _animated,
      );
      NoCodes.getSharedInstance().setScreenPresentationConfig(
        config,
        contextKey: contextKey.isEmpty ? null : contextKey,
      );
      debugPrint('✅ [NoCodes] Presentation config set');
      _showSuccess('Presentation config set!');
    } catch (e) {
      debugPrint('❌ [NoCodes] Failed to set config: $e');
      _showError('Failed to set config: $e');
    }
  }

  void _close() {
    try {
      debugPrint('🔄 [NoCodes] Closing...');
      NoCodes.getSharedInstance().close();
      debugPrint('✅ [NoCodes] Closed');
      _showInfo('No-Codes screen closed');
    } catch (e) {
      debugPrint('❌ [NoCodes] Failed to close: $e');
      _showError('Failed to close: $e');
    }
  }

  void _setLocale() async {
    final locale = _localeController.text.trim();
    final localeValue = locale.isEmpty ? null : locale;
    
    try {
      debugPrint('🔄 [NoCodes] Setting locale: $localeValue');
      await NoCodes.getSharedInstance().setLocale(localeValue);
      debugPrint('✅ [NoCodes] Locale set');
      _showSuccess(localeValue != null ? 'Locale set to: $localeValue' : 'Locale reset to device default');
    } catch (e) {
      debugPrint('❌ [NoCodes] Failed to set locale: $e');
      _showError('Failed to set locale: $e');
    }
  }

  void _resetLocale() async {
    try {
      debugPrint('🔄 [NoCodes] Resetting locale to device default...');
      await NoCodes.getSharedInstance().setLocale(null);
      _localeController.clear();
      debugPrint('✅ [NoCodes] Locale reset');
      _showSuccess('Locale reset to device default');
    } catch (e) {
      debugPrint('❌ [NoCodes] Failed to reset locale: $e');
      _showError('Failed to reset locale: $e');
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

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
