import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

import '../internal/mapper.dart';

part 'promotional_offer.g.dart';

@JsonSerializable()
class QPromotionalOffer {

  @JsonKey(fromJson: QMapper.requiredSkProductDiscountFromJson)
  final SKProductDiscount productDiscount;

  @JsonKey(fromJson: QMapper.skPaymentDiscountFromJson)
  final SKPaymentDiscount paymentDiscount;

  QPromotionalOffer(this.productDiscount, this.paymentDiscount);

  factory QPromotionalOffer.fromJson(Map<String, dynamic> json) =>
      _$QPromotionalOfferFromJson(json);

  Map<String, dynamic> toJson() => _$QPromotionalOfferToJson(this);
}
