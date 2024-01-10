import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/transaction_environment.dart';
import 'package:qonversion_flutter/src/dto/transaction_ownership_type.dart';
import 'package:qonversion_flutter/src/dto/transaction_type.dart';

import '../internal/mapper.dart';

part 'transaction.g.dart';

@JsonSerializable()
class QTransaction {
  @JsonKey(name: 'originalTransactionId')
  final String originalTransactionId;

  @JsonKey(name: 'transactionId')
  final String transactionId;

  @JsonKey(name: 'offerCode')
  final String? offerCode;

  @JsonKey(
    name: 'transactionTimestamp',
    fromJson: QMapper.dateTimeFromSecondsTimestamp,
  )
  final DateTime transactionDate;

  @JsonKey(
    name: 'expirationTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? expirationDate;

  @JsonKey(
    name: 'transactionRevocationTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? transactionRevocationDate;

  @JsonKey(
    name: 'environment',
    unknownEnumValue: QTransactionEnvironment.production,
  )
  final QTransactionEnvironment environment;

  @JsonKey(
    name: 'ownershipType',
    unknownEnumValue: QTransactionOwnershipType.owner,
  )
  final QTransactionOwnershipType ownershipType;

  @JsonKey(
    name: 'type',
    unknownEnumValue: QTransactionType.unknown,
  )
  final QTransactionType type;

  const QTransaction(
    this.originalTransactionId,
    this.transactionId,
    this.offerCode,
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
