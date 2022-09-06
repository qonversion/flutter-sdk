// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomationsEvent _$AutomationsEventFromJson(Map<String, dynamic> json) {
  return AutomationsEvent(
    _$enumDecode(_$AutomationsEventTypeEnumMap, json['type'],
        unknownValue: AutomationsEventType.unknown),
    QMapper.dateTimeFromSecondsTimestamp(json['timestamp'] as num),
  );
}

Map<String, dynamic> _$AutomationsEventToJson(AutomationsEvent instance) =>
    <String, dynamic>{
      'type': _$AutomationsEventTypeEnumMap[instance.type],
      'timestamp': instance.date.toIso8601String(),
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

const _$AutomationsEventTypeEnumMap = {
  AutomationsEventType.unknown: 'unknown',
  AutomationsEventType.trialStarted: 'trial_started',
  AutomationsEventType.trialConverted: 'trial_converted',
  AutomationsEventType.trialCanceled: 'trial_canceled',
  AutomationsEventType.trialBillingRetry: 'trial_billing_retry_entered',
  AutomationsEventType.subscriptionStarted: 'subscription_started',
  AutomationsEventType.subscriptionRenewed: 'subscription_renewed',
  AutomationsEventType.subscriptionRefunded: 'subscription_refunded',
  AutomationsEventType.subscriptionCanceled: 'subscription_canceled',
  AutomationsEventType.subscriptionBillingRetry:
      'subscription_billing_retry_entered',
  AutomationsEventType.inAppPurchase: 'in_app_purchase',
  AutomationsEventType.subscriptionUpgraded: 'subscription_upgraded',
  AutomationsEventType.trialStillActive: 'trial_still_active',
  AutomationsEventType.trialExpired: 'trial_expired',
  AutomationsEventType.subscriptionExpired: 'subscription_expired',
  AutomationsEventType.subscriptionDowngraded: 'subscription_downgraded',
  AutomationsEventType.subscriptionProductChanged:
      'subscription_product_changed',
};
