import 'purchase_update_model.dart';

/// A policy used for purchase updates on Android, which describes
/// how to migrate from purchased plan to a new one.
///
/// Used in [QPurchaseUpdateModel] class for purchase updates.
enum QPurchaseUpdatePolicy {

  /// The new plan takes effect immediately, and the user is charged full price of new plan
  /// and is given a full billing cycle of subscription, plus remaining prorated time
  /// from the old plan.
  chargeFullPrice,

  /// The new plan takes effect immediately, and the billing cycle remains the same.
  chargeProratedPrice,

  /// The new plan takes effect immediately, and the remaining time will be prorated
  /// and credited to the user.
  withTimeProration,

  /// The new purchase takes effect immediately, the new plan will take effect
  /// when the old item expires.
  deferred,

  /// The new plan takes effect immediately, and the new price will be charged
  /// on next recurrence time.
  withoutProration,

  /// Unknown police.
  unknown,
}