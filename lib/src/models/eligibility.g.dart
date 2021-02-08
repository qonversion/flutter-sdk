// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eligibility.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QEligibility _$QEligibilityFromJson(Map<String, dynamic> json) {
  return QEligibility(
    _$enumDecodeNullable(_$QEligibilityStatusEnumMap, json['status']) ??
        QEligibilityStatus.unknown,
  );
}

Map<String, dynamic> _$QEligibilityToJson(QEligibility instance) =>
    <String, dynamic>{
      'status': _$QEligibilityStatusEnumMap[instance.status],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$QEligibilityStatusEnumMap = {
  QEligibilityStatus.unknown: 0,
  QEligibilityStatus.nonIntroProduct: 1,
  QEligibilityStatus.ineligible: 2,
  QEligibilityStatus.eligible: 3,
};
