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

  /// Renews count for the entitlement. Renews count starts from the second paid subscription.
  ///  For example, we have 20 transactions. One is the trial, and one is the first paid transaction after the trial.
  ///  Renews count is equal to 18.
  @JsonKey(
    name: 'renewsCount',
    defaultValue: 0
  )
  final int renewsCount;

  /// Trial start date.
  @JsonKey(
    name: 'trialStartTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? trialStartDate;

  /// First purchase date.
  @JsonKey(
    name: 'firstPurchaseTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? firstPurchaseDate;

  /// Last purchase date.
  @JsonKey(
    name: 'lastPurchaseTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? lastPurchaseDate;

  /// Last activated offer code.
  @JsonKey(
    name: 'lastActivatedOfferCode'
  )
  final String? lastActivatedOfferCode;

  /// Grant type of the entitlement.
  @JsonKey(
    name: 'grantType',
    unknownEnumValue: QEntitlementGrantType.purchase,
    fromJson: QMapper.grantTypeFromNullableValue
  )
  final QEntitlementGrantType grantType;

  /// Auto-renew disable date.
  @JsonKey(
    name: 'autoRenewDisableTimestamp',
    fromJson: QMapper.dateTimeFromNullableSecondsTimestamp,
  )
  final DateTime? autoRenewDisableDate;

  /// Array of the transactions that unlocked current entitlement.
  @JsonKey(
    name: 'transactions',
    fromJson: QMapper.transactionsFromNullableValue
  )
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

  factory QEntitlement.fromJson(Map<String, dynamic> json) => _$QEntitlementFromJson(json);
}
