import 'package:json_annotation/json_annotation.dart';

enum QTransactionOwnershipType {
  @JsonValue('Owner')
  owner,

  @JsonValue('FamilySharing')
  familySharing,
}
