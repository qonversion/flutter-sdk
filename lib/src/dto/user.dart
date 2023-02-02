import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(createToJson: false)
class QUser {
  @JsonKey(name: "qonversionId")
  final String qonversionId;

  @JsonKey(name: "identityId")
  final String identityId;

  QUser(this.qonversionId, this.identityId);

  factory QUser.fromJson(Map<String, dynamic> json) =>
      _$QUserFromJson(json);
}
