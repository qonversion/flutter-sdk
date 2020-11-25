import 'package:in_app_purchase/billing_client_wrappers.dart';

class QDetailsSerializer {
  /// Returns [Map] from billing client's [SkuDetailsWrapper]
  static Map<String, dynamic> buildSkuMap(SkuDetailsWrapper original) {
    return <String, dynamic>{
      'description': original.description,
      'freeTrialPeriod': original.freeTrialPeriod,
      'introductoryPrice': original.introductoryPrice,
      'introductoryPriceMicros': original.introductoryPriceMicros,
      'introductoryPriceCycles': original.introductoryPriceCycles,
      'introductoryPricePeriod': original.introductoryPricePeriod,
      'price': original.price,
      'priceAmountMicros': original.priceAmountMicros,
      'priceCurrencyCode': original.priceCurrencyCode,
      'sku': original.sku,
      'subscriptionPeriod': original.subscriptionPeriod,
      'title': original.title,
      'type': original.type.toString().substring(8),
      'isRewarded': original.isRewarded,
      'originalPrice': original.originalPrice,
      'originalPriceAmountMicros': original.originalPriceAmountMicros,
    }..removeWhere((key, value) => value == null);
  }

  /// Returns [Map] from billing client's [PurchaseWrapper]
  static Map<String, dynamic> buildPurchaseMap(PurchaseWrapper original) {
    const _purchaseStateWrapperEnumMap = {
      PurchaseStateWrapper.unspecified_state: 0,
      PurchaseStateWrapper.purchased: 1,
      PurchaseStateWrapper.pending: 2,
    };
    return <String, dynamic>{
      'orderId': original.orderId,
      'packageName': original.packageName,
      'purchaseTime': original.purchaseTime,
      'signature': original.signature,
      'sku': original.sku,
      'purchaseToken': original.purchaseToken,
      'isAutoRenewing': original.isAutoRenewing,
      'originalJson': original.originalJson,
      'developerPayload': original.developerPayload,
      'purchaseState': _purchaseStateWrapperEnumMap[original.purchaseState],
      'isAcknowledged': original.isAcknowledged,
    }..removeWhere((key, value) => value == null);
  }
}
