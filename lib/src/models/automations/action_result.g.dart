// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionResult _$ActionResultFromJson(Map<String, dynamic> json) {
  return ActionResult(
    _$enumDecodeNullable(_$ActionResultTypeEnumMap, json['type']) ??
        ActionResultType.unknown,
    (json['value'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    QMapper.qonversionErrorFromJson(json['error']),
  );
}

Map<String, dynamic> _$ActionResultToJson(ActionResult instance) =>
    <String, dynamic>{
      'type': _$ActionResultTypeEnumMap[instance.type],
      'value': instance.parameters,
      'error': instance.error,
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

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$ActionResultTypeEnumMap = {
  ActionResultType.unknown: 'unknown',
  ActionResultType.url: 'url',
  ActionResultType.deepLink: 'deeplink',
  ActionResultType.navigation: 'navigate',
  ActionResultType.purchase: 'purchase',
  ActionResultType.restore: 'restore',
  ActionResultType.close: 'close',
};
