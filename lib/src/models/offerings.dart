import 'package:collection/collection.dart' show IterableExtension;
import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

part 'offerings.g.dart';

enum QOfferingTag {
  @JsonValue(0)
  none,
  @JsonValue(1)
  main,
}

@JsonSerializable(createToJson: false)
class QOfferings {
  @JsonKey(name: 'main')
  final QOffering? main;

  @JsonKey(name: 'available_offerings')
  final List<QOffering> availableOfferings;

  const QOfferings(this.main, this.availableOfferings);

  QOffering? offeringForIdentifier(String id) =>
      availableOfferings.firstWhereOrNull(
        (element) => element.id == id,
      );

  factory QOfferings.fromJson(Map<String, dynamic> json) =>
      _$QOfferingsFromJson(json);
}

@JsonSerializable(createToJson: false)
class QOffering {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'tag')
  final QOfferingTag tag;

  @JsonKey(name: 'products')
  final List<QProduct> products;

  const QOffering(this.id, this.tag, this.products);

  QProduct? productForIdentifier(String id) => products.firstWhereOrNull(
        (element) => element.qonversionId == id,
      );

  factory QOffering.fromJson(Map<String, dynamic> json) =>
      _$QOfferingFromJson(json);
}
