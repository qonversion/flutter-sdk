import 'package:json_annotation/json_annotation.dart';

part 'qonversion_error.g.dart';

@JsonSerializable()
class QError {
  /// Qonversion Error Code
  /// See more in [documentation](https://documentation.qonversion.io/docs/handling-errors)
  @JsonKey(name: 'code')
  final String code;

  /// Error description
  @JsonKey(name: 'description')
  final String message;

  /// Error details
  @JsonKey(name: 'additionalMessage')
  final String? details;

  const QError(this.code, this.message, this.details);

  factory QError.fromJson(Map<String, dynamic> json) => _$QErrorFromJson(json);

  Map<String, dynamic> toJson() => _$QErrorToJson(this);

  @override
  String toString() {
    return 'Qonversion Error.\nCode: $code, Message: $message, Details: $details';
  }
}
