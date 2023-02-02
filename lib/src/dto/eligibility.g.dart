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

const _$QEligibilityStatusEnumMap = {
  QEligibilityStatus.unknown: 'unknown',
  QEligibilityStatus.nonIntroProduct: 'non_intro_or_trial_product',
  QEligibilityStatus.ineligible: 'intro_or_trial_ineligible',
  QEligibilityStatus.eligible: 'intro_or_trial_eligible',
};
