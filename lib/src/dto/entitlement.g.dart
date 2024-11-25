// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entitlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QEntitlement _$QEntitlementFromJson(Map<String, dynamic> json) => QEntitlement(
      json['id'] as String,
      json['productId'] as String,
      $enumDecode(_$QEntitlementRenewStateEnumMap, json['renewState'],
          unknownValue: QEntitlementRenewState.unknown),
      $enumDecode(_$QEntitlementSourceEnumMap, json['source'],
          unknownValue: QEntitlementSource.unknown),
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['startedTimestamp'] as num?),
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['expirationTimestamp'] as num?),
      json['active'] as bool,
      (json['renewsCount'] as num?)?.toInt() ?? 0,
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['trialStartTimestamp'] as num?),
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['firstPurchaseTimestamp'] as num?),
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['lastPurchaseTimestamp'] as num?),
      json['lastActivatedOfferCode'] as String?,
      QMapper.grantTypeFromNullableValue(json['grantType'] as String?),
      QMapper.dateTimeFromNullableSecondsTimestamp(
          json['autoRenewDisableTimestamp'] as num?),
      QMapper.transactionsFromNullableValue(json['transactions'] as List?),
    );

const _$QEntitlementRenewStateEnumMap = {
  QEntitlementRenewState.nonRenewable: 'non_renewable',
  QEntitlementRenewState.unknown: 'unknown',
  QEntitlementRenewState.willRenew: 'will_renew',
  QEntitlementRenewState.canceled: 'canceled',
  QEntitlementRenewState.billingIssue: 'billing_issue',
};

const _$QEntitlementSourceEnumMap = {
  QEntitlementSource.unknown: 'Unknown',
  QEntitlementSource.appStore: 'AppStore',
  QEntitlementSource.playStore: 'PlayStore',
  QEntitlementSource.stripe: 'Stripe',
  QEntitlementSource.manual: 'Manual',
};
