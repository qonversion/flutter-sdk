import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/transaction_environment.dart';
import 'package:qonversion_flutter/src/dto/transaction_ownership_type.dart';
import 'package:qonversion_flutter/src/dto/transaction_type.dart';

import '../internal/mapper.dart';

part 'transaction.g.dart';

@JsonSerializable(createToJson: false)
class QTransaction {
  /// Original transaction identifier.
  @JsonKey(name: 'originalTransactionId')
  final String originalTransactionId;

  /// Transaction identifier.
  @JsonKey(name: 'transactionId')
  final String transactionId;

  /// Offer code.
  @JsonKey(name: 'offerCode')
  final String? offerCode;

  /// Promotional offer id.
  @JsonKey(name: 'promoOfferId')
  final String? promoOfferId;

  /// Transaction date.
  @JsonKey(
    name: 'transactionTimestamp',
    fromJson: QMapper.dateTimeFromSecondsTimestamp,
  )
  final DateTime transactionDate;

  /// Expiration date for subscriptions.
  @JsonKey(
    name: 'expirationTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? expirationDate;

  /// The date when transaction was revoked.
  /// This field represents the time and date the App Store refunded a transaction or revoked it from family sharing.
  @JsonKey(
    name: 'transactionRevocationTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? transactionRevocationDate;

  /// Environment of the transaction.
  @JsonKey(
    name: 'environment',
    unknownEnumValue: QTransactionEnvironment.production,
  )
  final QTransactionEnvironment environment;

  /// Type of ownership for the transaction.  Owner/Family sharing.
  @JsonKey(
    name: 'ownershipType',
    unknownEnumValue: QTransactionOwnershipType.owner,
  )
  final QTransactionOwnershipType ownershipType;

  /// Type of the transaction.
  @JsonKey(
    name: 'type',
    unknownEnumValue: QTransactionType.unknown,
  )
  final QTransactionType type;

  const QTransaction(
    this.originalTransactionId,
    this.transactionId,
    this.offerCode,
    this.promoOfferId,
    this.transactionDate,
    this.expirationDate,
    this.transactionRevocationDate,
    this.environment,
    this.ownershipType,
    this.type,
  );

  factory QTransaction.fromJson(Map<String, dynamic> json) =>
      _$QTransactionFromJson(json);
}
