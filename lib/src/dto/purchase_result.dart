import '../internal/mapper.dart';
import 'entitlement.dart';
import 'purchase_result_source.dart';
import 'purchase_result_status.dart';
import 'qonversion_error.dart';
import 'store_transaction.dart';

/// Represents the result of a purchase operation.
/// Contains the status of the purchase, entitlements, and store transaction details.
class QPurchaseResult {
  /// The status of the purchase operation.
  final QPurchaseResultStatus status;

  /// The user's entitlements after the purchase.
  /// May be null if the purchase failed or is pending.
  final Map<String, QEntitlement>? entitlements;

  /// The error that occurred during the purchase, if any.
  final QError? error;

  /// Indicates whether the entitlements were generated from a fallback source.
  final bool isFallbackGenerated;

  /// The source of the purchase result data.
  final QPurchaseResultSource source;

  /// The store transaction details from the native platform.
  /// Contains raw transaction information from Apple App Store or Google Play Store.
  final QStoreTransaction? storeTransaction;

  const QPurchaseResult({
    required this.status,
    this.entitlements,
    this.error,
    required this.isFallbackGenerated,
    required this.source,
    this.storeTransaction,
  });

  factory QPurchaseResult.fromJson(Map<String, dynamic> json) {
    return QPurchaseResult(
      status: QMapper.purchaseResultStatusFromString(json['status'] as String?),
      entitlements: QMapper.entitlementsFromNullableMap(json['entitlements']),
      error: QMapper.qonversionErrorFromJson(json['error']),
      isFallbackGenerated: json['isFallbackGenerated'] as bool? ?? false,
      source: QMapper.purchaseResultSourceFromString(json['source'] as String?),
      storeTransaction: QMapper.storeTransactionFromJson(json['storeTransaction']),
    );
  }

  /// Returns true if the purchase was successful.
  bool get isSuccess => status == QPurchaseResultStatus.success;

  /// Returns true if the purchase was canceled by the user.
  bool get isCanceled => status == QPurchaseResultStatus.userCanceled;

  /// Returns true if the purchase is pending.
  bool get isPending => status == QPurchaseResultStatus.pending;

  /// Returns true if an error occurred during the purchase.
  bool get isError => status == QPurchaseResultStatus.error;
}
