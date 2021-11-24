import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/models/utils/mapper.dart';

import 'event_type.dart';

part 'event.g.dart';

@JsonSerializable()
class AutomationsEvent {
  @JsonKey(
    name: 'event_type',
    unknownEnumValue: AutomationsEventType.unknown,
  )
  final AutomationsEventType type;

  @JsonKey(
    name: 'date',
    fromJson: QMapper.dateTimeFromSecondsTimestamp,
  )
  final DateTime date;

  const AutomationsEvent(this.type, this.date);

  factory AutomationsEvent.fromJson(Map<String, dynamic> json) =>
      _$AutomationsEventFromJson(json);

  Map<String, dynamic> toJson() => _$AutomationsEventToJson(this);
}
