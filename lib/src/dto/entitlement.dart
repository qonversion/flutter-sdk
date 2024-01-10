import 'package:json_annotation/json_annotation.dart';
import 'package:qonversion_flutter/src/dto/entitlement_source.dart';
import 'package:qonversion_flutter/src/dto/entitlement_renew_state.dart';
import 'package:qonversion_flutter/src/dto/transaction.dart';
import 'package:qonversion_flutter/src/internal/mapper.dart';

import 'entitlement_grant_type.dart';

part 'entitlement.g.dart';

@JsonSerializable(createToJson: false)
class QEntitlement {
  /// Qonversion Entitlement ID, like premium.
  ///
  /// See [Create Entitlement](https://qonversion.io/docs/create-entitlement)
  @JsonKey(name: 'id')
  final String id;

  /// Product ID created in Qonversion Dashboard.
  ///
  /// See [Create Products](https://qonversion.io/docs/create-products)
  @JsonKey(name: 'productId')
  final String productId;

  /// A renew state for an associate product that unlocked entitlement
  @JsonKey(
    name: 'renewState',
    unknownEnumValue: QEntitlementRenewState.unknown,
  )
  final QEntitlementRenewState renewState;

  /// A source determining where this entitlement is originally from - App Store, Play Store, Stripe, etc.
  @JsonKey(
    name: 'source',
    unknownEnumValue: QEntitlementSource.unknown,
  )
  final QEntitlementSource source;

  /// Purchase date
  @JsonKey(
    name: 'startedTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? startedDate;

  /// Expiration date for subscription
  @JsonKey(
    name: 'expirationTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? expirationDate;

  @JsonKey(name: 'renewsCount')
  final int renewsCount;

  @JsonKey(
    name: 'trialStartTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? trialStartDate;

  @JsonKey(
    name: 'firstPurchaseTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? firstPurchaseDate;

  @JsonKey(
    name: 'lastPurchaseTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? lastPurchaseDate;

  @JsonKey(
    name: 'lastActivatedOfferCode'
  )
  final String? lastActivatedOfferCode;

  @JsonKey(
    name: 'grantType',
    unknownEnumValue: QEntitlementGrantType.purchase,
  )
  final QEntitlementGrantType grantType;

  @JsonKey(
    name: 'autoRenewDisableTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? autoRenewDisableDate;

  @JsonKey(name: 'transactions')
  final List<QTransaction> transactions;

  /// Use for checking entitlement for current user.
  /// Pay attention, isActive == true does not mean that subscription is renewable.
  /// Subscription could be canceled, but the user could still have a entitlement
  @JsonKey(name: 'active')
  final bool isActive;

  const QEntitlement(
    this.id,
    this.productId,
    this.renewState,
    this.source,
    this.startedDate,
    this.expirationDate,
    this.isActive,
    this.renewsCount,
    this.trialStartDate,
    this.firstPurchaseDate,
    this.lastPurchaseDate,
    this.lastActivatedOfferCode,
    this.grantType,
    this.autoRenewDisableDate,
    this.transactions
  );

  factory QEntitlement.fromJson(Map<String, dynamic> json) =>
      _$QEntitlementFromJson(json);
}
