// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qonversion_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QError _$QErrorFromJson(Map<String, dynamic> json) {
  return QError(
    _$enumDecode(_$QErrorCodeEnumMap, json['code'],
        unknownValue: QErrorCode.unknown),
    json['description'] as String,
    json['additionalMessage'] as String?,
  );
}

Map<String, dynamic> _$QErrorToJson(QError instance) => <String, dynamic>{
      'code': _$QErrorCodeEnumMap[instance.code],
      'description': instance.message,
      'additionalMessage': instance.details,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$QErrorCodeEnumMap = {
  QErrorCode.unknown: 'Unknown',
  QErrorCode.apiRateLimitExceeded: 'ApiRateLimitExceeded',
  QErrorCode.appleStoreError: 'AppleStoreError',
  QErrorCode.backendError: 'BackendError',
  QErrorCode.billingUnavailable: 'BillingUnavailable',
  QErrorCode.clientInvalid: 'ClientInvalid',
  QErrorCode.cloudServiceNetworkConnectionFailed:
      'CloudServiceNetworkConnectionFailed',
  QErrorCode.cloudServicePermissionDenied: 'CloudServicePermissionDenied',
  QErrorCode.cloudServiceRevoked: 'CloudServiceRevoked',
  QErrorCode.failedToReceiveData: 'FailedToReceiveData',
  QErrorCode.featureNotSupported: 'FeatureNotSupported',
  QErrorCode.fraudPurchase: 'FraudPurchase',
  QErrorCode.incorrectRequest: 'IncorrectRequest',
  QErrorCode.internalError: 'InternalError',
  QErrorCode.invalidClientUid: 'InvalidClientUid',
  QErrorCode.invalidCredentials: 'InvalidCredentials',
  QErrorCode.invalidStoreCredentials: 'InvalidStoreCredentials',
  QErrorCode.launchError: 'LaunchError',
  QErrorCode.networkConnectionFailed: 'NetworkConnectionFailed',
  QErrorCode.offeringsNotFound: 'OfferingsNotFound',
  QErrorCode.paymentInvalid: 'PaymentInvalid',
  QErrorCode.paymentNotAllowed: 'PaymentNotAllowed',
  QErrorCode.playStoreError: 'PlayStoreError',
  QErrorCode.privacyAcknowledgementRequired: 'PrivacyAcknowledgementRequired',
  QErrorCode.productAlreadyOwned: 'ProductAlreadyOwned',
  QErrorCode.productNotFound: 'ProductNotFound',
  QErrorCode.productNotOwned: 'ProductNotOwned',
  QErrorCode.projectConfigError: 'ProjectConfigError',
  QErrorCode.purchaseCanceled: 'PurchaseCanceled',
  QErrorCode.purchaseInvalid: 'PurchaseInvalid',
  QErrorCode.purchasePending: 'PurchasePending',
  QErrorCode.purchaseUnspecified: 'PurchaseUnspecified',
  QErrorCode.receiptValidationError: 'ReceiptValidationError',
  QErrorCode.remoteConfigurationNotAvailable: 'RemoteConfigurationNotAvailable',
  QErrorCode.responseParsingFailed: 'ResponseParsingFailed',
  QErrorCode.storeProductNotAvailable: 'StoreProductNotAvailable',
  QErrorCode.unauthorizedRequestData: 'UnauthorizedRequestData',
  QErrorCode.unknownClientPlatform: 'UnknownClientPlatform',
};
