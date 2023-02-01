import 'package:qonversion_flutter/src/qonversion_config.dart';

import '../qonversion_flutter.dart';

class QonversionConfigBuilder {
  final String projectKey;

  final QLaunchMode launchMode;

  QEnvironment _environment = QEnvironment.production;

  QEntitlementsCacheLifetime _entitlementsCacheLifetime = QEntitlementsCacheLifetime.month;

  String? _proxyUrl = null;

  QonversionConfigBuilder(this.projectKey, this.launchMode);


  /// Set current application [QEnvironment]. Used to distinguish sandbox and production users.
  ///
  /// [environment] current environment.
  /// Returns builder instance for chain calls.
  QonversionConfigBuilder setEnvironment(QEnvironment environment) {
    _environment = environment;
    return this;
  }

  /// Entitlements cache is used when there are problems with the Qonversion API
  /// or internet connection. If so, Qonversion will return the last successfully loaded
  /// entitlements. The current method allows you to configure how long that cache may be used.
  /// The default value is [QEntitlementsCacheLifetime.month].
  ///
  /// [lifetime] desired entitlements cache lifetime duration
  /// Returns builder instance for chain calls.
  QonversionConfigBuilder setEntitlementsCacheLifetime(QEntitlementsCacheLifetime lifetime) {
    _entitlementsCacheLifetime = lifetime;
    return this;
  }

  /// Provide a URL to your proxy server which will redirect all the requests from the app
  /// to our API. Please, contact us before using this feature.
  ///
  /// [url] your proxy server url
  /// Returns builder instance for chain calls.
  /// See [the documentation](https://documentation.qonversion.io/docs/custom-proxy-server-for-sdks)
  QonversionConfigBuilder setProxyURL(String url) {
    _proxyUrl = url;
    return this;
  }

  /// Generate [QonversionConfig] instance with all the provided configurations.
  ///
  /// Returns the complete [QonversionConfig] instance.
  QonversionConfig build() {
    return new QonversionConfig(
      projectKey,
      launchMode,
      _environment,
      _entitlementsCacheLifetime,
      _proxyUrl
    );
  }
}
