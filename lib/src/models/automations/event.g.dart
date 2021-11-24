// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomationsEvent _$AutomationsEventFromJson(Map<String, dynamic> json) {
  return AutomationsEvent(
    _$enumDecode(_$AutomationsEventTypeEnumMap, json['event_type'],
        unknownValue: AutomationsEventType.unknown),
    QMapper.dateTimeFromSecondsTimestamp(json['date'] as num),
  );
}

Map<String, dynamic> _$AutomationsEventToJson(AutomationsEvent instance) =>
    <String, dynamic>{
      'event_type': _$AutomationsEventTypeEnumMap[instance.type],
      'date': instance.date.toIso8601String(),
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
  AutomationsEventType.unknown: 0,
  AutomationsEventType.trialStarted: 1,
  AutomationsEventType.trialConverted: 2,
  AutomationsEventType.trialCanceled: 3,
  AutomationsEventType.trialBillingRetry: 4,
  AutomationsEventType.subscriptionStarted: 5,
  AutomationsEventType.subscriptionRenewed: 6,
  AutomationsEventType.subscriptionRefunded: 7,
  AutomationsEventType.subscriptionCanceled: 8,
  AutomationsEventType.subscriptionBillingRetry: 9,
  AutomationsEventType.inAppPurchase: 10,
  AutomationsEventType.subscriptionUpgraded: 11,
  AutomationsEventType.trialStillActive: 12,
  AutomationsEventType.trialExpired: 13,
  AutomationsEventType.subscriptionExpired: 14,
  AutomationsEventType.subscriptionDowngraded: 15,
  AutomationsEventType.subscriptionProductChanged: 16,
};
