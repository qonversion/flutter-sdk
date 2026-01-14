import 'nocodes_config.dart';
import 'nocodes_purchase_delegate.dart';

/// Builder for No-Codes configuration
class NoCodesConfigBuilder {
  final String projectKey;
  String? proxyUrl;
  String? locale;
  NoCodesPurchaseDelegate? purchaseDelegate;

  NoCodesConfigBuilder(this.projectKey);

  /// Set proxy URL for No-Codes initialization.
  ///
  /// [proxyUrl] the proxy URL to use.
  /// Returns the builder instance for method chaining.
  NoCodesConfigBuilder setProxyUrl(String? proxyUrl) {
    this.proxyUrl = proxyUrl;
    return this;
  }

  /// Set the locale for No-Code screens.
  /// Use this to override the device locale for the No-Codes SDK.
  ///
  /// [locale] the locale to use (e.g. "en", "de", "fr").
  /// Returns the builder instance for method chaining.
  NoCodesConfigBuilder setLocale(String locale) {
    this.locale = locale;
    return this;
  }

  /// Provide a delegate for custom purchase and restore handling.
  /// When this delegate is provided, it replaces the default Qonversion SDK purchase flow.
  ///
  /// [purchaseDelegate] delegate to handle purchase and restore operations.
  /// Returns the builder instance for method chaining.
  NoCodesConfigBuilder setPurchaseDelegate(NoCodesPurchaseDelegate purchaseDelegate) {
    this.purchaseDelegate = purchaseDelegate;
    return this;
  }

  /// Generate [NoCodesConfig] instance with all the provided configurations.
  ///
  /// Returns the complete [NoCodesConfig] instance.
  NoCodesConfig build() {
    return NoCodesConfig(
      projectKey,
      proxyUrl: proxyUrl,
      locale: locale,
      purchaseDelegate: purchaseDelegate,
    );
  }
}