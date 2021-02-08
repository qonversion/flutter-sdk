import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

part 'offerings.g.dart';

@JsonSerializable(createToJson: false)
class QOfferings {
  @JsonKey(name: 'main')
  final QOffering main;

  @JsonKey(name: 'available_offerings')
  final List<QOffering> availableOfferings;

  const QOfferings(this.main, this.availableOfferings);

  QOffering offeringForIdentifier(String id) => availableOfferings.firstWhere(
        (element) => element.id == id,
        orElse: () => null,
      );

  factory QOfferings.fromJson(Map<String, dynamic> json) =>
      _$QOfferingsFromJson(json);
}

@JsonSerializable(createToJson: false)
class QOffering {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tag')
  final int tag;

  @JsonKey(name: 'products')
  final List<QProduct> products;

  const QOffering(this.id, this.tag, this.products);

  QProduct productForIdentifier(String id) => products.firstWhere(
        (element) => element.qonversionId == id,
        orElse: () => null,
      );

  factory QOffering.fromJson(Map<String, dynamic> json) =>
      _$QOfferingFromJson(json);
}
