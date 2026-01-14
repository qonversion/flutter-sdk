import '../internal/mapper.dart';

/// Represents a raw store transaction from the native platform.
/// This is the transaction information as received from Apple App Store or Google Play Store.
class QStoreTransaction {
  /// The unique identifier for this transaction.
  final String? transactionId;

  /// The original transaction identifier.
  /// For subscriptions, this identifies the first transaction in the subscription chain.
  final String? originalTransactionId;

  /// The date and time when the transaction occurred.
  final DateTime? transactionDate;

  /// The store product identifier associated with this transaction.
  final String? productId;

  /// The quantity of items purchased.
  final int quantity;

  /// iOS only. The identifier of the promotional offer applied to this purchase.
  final String? promoOfferId;

  /// Android only. The purchase token from Google Play.
  final String? purchaseToken;

  const QStoreTransaction({
    required this.transactionId,
    required this.originalTransactionId,
    required this.transactionDate,
    required this.productId,
    required this.quantity,
    this.promoOfferId,
    this.purchaseToken,
  });

  factory QStoreTransaction.fromJson(Map<String, dynamic> json) {
    return QStoreTransaction(
      transactionId: json['transactionId'] as String?,
      originalTransactionId: json['originalTransactionId'] as String?,
      transactionDate: QMapper.dateTimeFromNullableMillisTimestamp(
        json['transactionTimestamp'] as num?,
      ),
      productId: json['productId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      promoOfferId: json['promoOfferId'] as String?,
      purchaseToken: json['purchaseToken'] as String?,
    );
  }
}
