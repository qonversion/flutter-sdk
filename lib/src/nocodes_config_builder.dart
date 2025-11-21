import 'nocodes_config.dart';

/// Builder for No-Codes configuration
class NoCodesConfigBuilder {
  final String projectKey;
  String? proxyUrl;

  NoCodesConfigBuilder(this.projectKey);

  /// Set proxy URL for No-Codes initialization.
  ///
  /// [proxyUrl] the proxy URL to use.
  /// Returns the builder instance for method chaining.
  NoCodesConfigBuilder setProxyUrl(String? proxyUrl) {
    this.proxyUrl = proxyUrl;
    return this;
  }

  /// Generate [NoCodesConfig] instance with all the provided configurations.
  ///
  /// Returns the complete [NoCodesConfig] instance.
  NoCodesConfig build() {
    return NoCodesConfig(projectKey, proxyUrl: proxyUrl);
  }
}