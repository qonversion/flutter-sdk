/// Represents a completed deferred purchase transaction with full details.
class QDeferredTransaction {
  /// Store product identifier.
  final String productId;

  /// Store transaction identifier.
  final String? transactionId;

  /// Original store transaction identifier.
  /// For subscriptions, this is the ID of the first transaction.
  final String? originalTransactionId;

  /// Type of the transaction: Subscription, Consumable, NonConsumable, or Unknown.
  final String type;

  /// Transaction value. May be 0 if unavailable.
  final double value;

  /// Currency code (e.g. "USD"). May be null if unavailable.
  final String? currency;

  QDeferredTransaction(
    this.productId,
    this.transactionId,
    this.originalTransactionId,
    this.type,
    this.value,
    this.currency,
  );

  factory QDeferredTransaction.fromJson(Map<String, dynamic> json) {
    return QDeferredTransaction(
      json['productId'] as String? ?? '',
      json['transactionId'] as String?,
      json['originalTransactionId'] as String?,
      json['type'] as String? ?? 'Unknown',
      (json['value'] as num?)?.toDouble() ?? 0.0,
      json['currency'] as String?,
    );
  }
}
