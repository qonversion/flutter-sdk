import 'package:json_annotation/json_annotation.dart';

enum QEntitlementGrantType {
  @JsonValue('Purchase')
  purchase,

  @JsonValue('FamilySharing')
  familySharing,

  @JsonValue('OfferCode')
  offerCode,

  @JsonValue('Manual')
  manual,
}
