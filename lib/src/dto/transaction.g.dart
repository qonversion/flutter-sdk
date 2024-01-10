// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QTransaction _$QTransactionFromJson(Map<String, dynamic> json) {
  return QTransaction(
    json['originalTransactionId'] as String,
    json['transactionId'] as String,
    json['offerCode'] as String?,
    QMapper.dateTimeFromSecondsTimestamp(json['transactionTimestamp'] as num),
    QMapper.dateTimeFromNullableSecondsTimestamp(
        json['expirationTimestamp'] as num?),
    QMapper.dateTimeFromNullableSecondsTimestamp(
        json['transactionRevocationTimestamp'] as num?),
    _$enumDecode(_$QTransactionEnvironmentEnumMap, json['environment'],
        unknownValue: QTransactionEnvironment.production),
    _$enumDecode(_$QTransactionOwnershipTypeEnumMap, json['ownershipType'],
        unknownValue: QTransactionOwnershipType.owner),
    _$enumDecode(_$QTransactionTypeEnumMap, json['type'],
        unknownValue: QTransactionType.unknown),
  );
}

Map<String, dynamic> _$QTransactionToJson(QTransaction instance) =>
    <String, dynamic>{
      'originalTransactionId': instance.originalTransactionId,
      'transactionId': instance.transactionId,
      'offerCode': instance.offerCode,
      'transactionTimestamp': instance.transactionDate.toIso8601String(),
      'expirationTimestamp': instance.expirationDate?.toIso8601String(),
      'transactionRevocationTimestamp':
          instance.transactionRevocationDate?.toIso8601String(),
      'environment': _$QTransactionEnvironmentEnumMap[instance.environment],
      'ownershipType':
          _$QTransactionOwnershipTypeEnumMap[instance.ownershipType],
      'type': _$QTransactionTypeEnumMap[instance.type],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$QTransactionEnvironmentEnumMap = {
  QTransactionEnvironment.production: 'Production',
  QTransactionEnvironment.sandbox: 'Sandbox',
};

const _$QTransactionOwnershipTypeEnumMap = {
  QTransactionOwnershipType.owner: 'Owner',
  QTransactionOwnershipType.familySharing: 'FamilySharing',
};

const _$QTransactionTypeEnumMap = {
  QTransactionType.unknown: 'Unknown',
  QTransactionType.subscriptionStarted: 'SubscriptionStarted',
  QTransactionType.subscriptionRenewed: 'SubscriptionRenewed',
  QTransactionType.trialStrated: 'TrialStarted',
  QTransactionType.introStarted: 'IntroStarted',
  QTransactionType.introRenewed: 'IntroRenewed',
  QTransactionType.nonConsumablePurchase: 'NonConsumablePurchase',
};
