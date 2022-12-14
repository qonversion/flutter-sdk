import '../qonversion_flutter.dart';

class QonversionConfig {
  final String projectKey;

  final QLaunchMode launchMode;

  final QEnvironment environment;

  final QEntitlementsCacheLifetime entitlementsCacheLifetime;

  QonversionConfig(this.projectKey, this.launchMode, this.environment, this.entitlementsCacheLifetime);
}
