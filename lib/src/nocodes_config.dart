import 'dto/nocodes_theme.dart';
import 'nocodes_purchase_delegate.dart';

/// Configuration for No-Codes initialization
class NoCodesConfig {
  final String projectKey;
  final String? proxyUrl;
  final String? locale;
  final NoCodesTheme? theme;
  final NoCodesPurchaseDelegate? purchaseDelegate;

  const NoCodesConfig(
    this.projectKey, {
    this.proxyUrl,
    this.locale,
    this.theme,
    this.purchaseDelegate,
  });
}