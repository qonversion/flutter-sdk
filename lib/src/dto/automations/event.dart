import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';

import 'event_type.dart';

part 'event.g.dart';

@JsonSerializable()
class AutomationsEvent {
  @JsonKey(
    name: 'type',
    unknownEnumValue: AutomationsEventType.unknown,
  )
  final AutomationsEventType type;

  @JsonKey(
    name: 'timestamp',
    fromJson: QMapper.dateTimeFromSecondsTimestamp,
  )
  final DateTime date;

  const AutomationsEvent(this.type, this.date);

  factory AutomationsEvent.fromJson(Map<String, dynamic> json) =>
      _$AutomationsEventFromJson(json);

  Map<String, dynamic> toJson() => _$AutomationsEventToJson(this);
}
