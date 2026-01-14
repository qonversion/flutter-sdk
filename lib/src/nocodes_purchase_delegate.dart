import 'dto/product.dart';

/// Delegate responsible for custom purchase and restore handling in No-Codes.
/// When this delegate is provided, it replaces the default Qonversion SDK purchase flow,
/// allowing you to use your own purchase system (e.g., RevenueCat, custom backend, etc.).
///
/// Implement this class and pass it to [NoCodesConfigBuilder.setPurchaseDelegate]
/// to handle purchases initiated from No-Code screens with your own logic.
///
/// Example:
/// ```dart
/// class MyPurchaseDelegate implements NoCodesPurchaseDelegate {
///   @override
///   Future<void> purchase(QProduct product) async {
///     // Handle purchase with your own purchase system
///     // Use product.storeId to get the store product identifier
///     await MyPurchaseSystem.purchase(product.storeId);
///   }
///
///   @override
///   Future<void> restore() async {
///     // Handle restore with your own purchase system
///     await MyPurchaseSystem.restorePurchases();
///   }
/// }
/// ```
abstract class NoCodesPurchaseDelegate {
  /// Handle purchase for the given product.
  ///
  /// This method is called when a purchase is initiated from a No-Code screen.
  /// Implement your custom purchase logic here.
  ///
  /// [product] - The product to purchase.
  ///
  /// The returned Future should complete successfully when the purchase finishes,
  /// or throw an exception if the purchase fails.
  Future<void> purchase(QProduct product);

  /// Handle restore flow.
  ///
  /// This method is called when a restore is initiated from a No-Code screen.
  /// Implement your custom restore logic here.
  ///
  /// The returned Future should complete successfully when the restore finishes,
  /// or throw an exception if the restore fails.
  Future<void> restore();
}
