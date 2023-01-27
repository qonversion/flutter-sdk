// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_presentation_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QScreenPresentationConfig _$QScreenPresentationConfigFromJson(
    Map<String, dynamic> json) {
  return QScreenPresentationConfig(
    _$enumDecode(_$QScreenPresentationStyleEnumMap, json['presentationStyle']),
    json['animate'] as bool,
  );
}

Map<String, dynamic> _$QScreenPresentationConfigToJson(
        QScreenPresentationConfig instance) =>
    <String, dynamic>{
      'presentationStyle':
          _$QScreenPresentationStyleEnumMap[instance.presentationStyle],
      'animate': instance.animate,
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

const _$QScreenPresentationStyleEnumMap = {
  QScreenPresentationStyle.push: 'Push',
  QScreenPresentationStyle.fullScreen: 'FullScreen',
  QScreenPresentationStyle.popover: 'Popover',
  QScreenPresentationStyle.noAnimation: 'NoAnimation',
};
