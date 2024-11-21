// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QTransaction _$QTransactionFromJson(Map<String, dynamic> json) => QTransaction(
      json['originalTransactionId'] as String,
      json['transactionId'] as String,
      json['offerCode'] as String?,
      json['promoOfferId'] as String?,
      QMapper.dateTimeFromSecondsTimestamp(json['transactionTimestamp'] as num),
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['expirationTimestamp'] as num?),
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['transactionRevocationTimestamp'] as num?),
      $enumDecode(_$QTransactionEnvironmentEnumMap, json['environment'],
          unknownValue: QTransactionEnvironment.production),
      $enumDecode(_$QTransactionOwnershipTypeEnumMap, json['ownershipType'],
          unknownValue: QTransactionOwnershipType.owner),
      $enumDecode(_$QTransactionTypeEnumMap, json['type'],
          unknownValue: QTransactionType.unknown),
    );

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
