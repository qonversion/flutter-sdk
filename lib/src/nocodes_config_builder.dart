import 'nocodes_config.dart';

/// Builder for NoCodes configuration
class NoCodesConfigBuilder {
  final String projectKey;

  NoCodesConfigBuilder(this.projectKey);

  /// Generate [NoCodesConfig] instance with all the provided configurations.
  ///
  /// Returns the complete [NoCodesConfig] instance.
  NoCodesConfig build() {
    return NoCodesConfig(projectKey);
  }
}