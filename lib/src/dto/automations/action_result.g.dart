// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionResult _$ActionResultFromJson(Map<String, dynamic> json) => ActionResult(
      $enumDecodeNullable(_$ActionResultTypeEnumMap, json['type']) ??
          ActionResultType.unknown,
      (json['value'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      QMapper.qonversionErrorFromJson(json['error']),
    );

Map<String, dynamic> _$ActionResultToJson(ActionResult instance) =>
    <String, dynamic>{
      'type': _$ActionResultTypeEnumMap[instance.type]!,
      'value': instance.parameters,
      'error': instance.error,
    };

const _$ActionResultTypeEnumMap = {
  ActionResultType.unknown: 'unknown',
  ActionResultType.url: 'url',
  ActionResultType.deepLink: 'deeplink',
  ActionResultType.navigation: 'navigate',
  ActionResultType.purchase: 'purchase',
  ActionResultType.restore: 'restore',
  ActionResultType.close: 'close',
};
