import 'package:json_annotation/json_annotation.dart';

enum QErrorCode {
  @JsonValue('Unknown')
  unknown,

  @JsonValue('ApiRateLimitExceeded')
  apiRateLimitExceeded,

  @JsonValue('AppleStoreError')
  appleStoreError,

  @JsonValue('BackendError')
  backendError,

  @JsonValue('BillingUnavailable')
  billingUnavailable,

  @JsonValue('ClientInvalid')
  clientInvalid,

  @JsonValue('CloudServiceNetworkConnectionFailed')
  cloudServiceNetworkConnectionFailed,

  @JsonValue('CloudServicePermissionDenied')
  cloudServicePermissionDenied,

  @JsonValue('CloudServiceRevoked')
  cloudServiceRevoked,

  @JsonValue('FailedToReceiveData')
  failedToReceiveData,

  @JsonValue('FeatureNotSupported')
  featureNotSupported,

  @JsonValue('FraudPurchase')
  fraudPurchase,

  @JsonValue('IncorrectRequest')
  incorrectRequest,

  @JsonValue('InternalError')
  internalError,

  @JsonValue('InvalidClientUid')
  invalidClientUid,

  @JsonValue('InvalidCredentials')
  invalidCredentials,

  @JsonValue('InvalidStoreCredentials')
  invalidStoreCredentials,

  @JsonValue('LaunchError')
  launchError,

  @JsonValue('NetworkConnectionFailed')
  networkConnectionFailed,

  @JsonValue('OfferingsNotFound')
  offeringsNotFound,

  @JsonValue('PaymentInvalid')
  paymentInvalid,

  @JsonValue('PaymentNotAllowed')
  paymentNotAllowed,

  @JsonValue('PlayStoreError')
  playStoreError,

  @JsonValue('PrivacyAcknowledgementRequired')
  privacyAcknowledgementRequired,

  @JsonValue('ProductAlreadyOwned')
  productAlreadyOwned,

  @JsonValue('ProductNotFound')
  productNotFound,

  @JsonValue('ProductNotOwned')
  productNotOwned,

  @JsonValue('ProjectConfigError')
  projectConfigError,

  @JsonValue('PurchaseCanceled')
  purchaseCanceled,

  @JsonValue('PurchaseInvalid')
  purchaseInvalid,

  @JsonValue('PurchasePending')
  purchasePending,

  @JsonValue('PurchaseUnspecified')
  purchaseUnspecified,

  @JsonValue('ReceiptValidationError')
  receiptValidationError,

  @JsonValue('RemoteConfigurationNotAvailable')
  remoteConfigurationNotAvailable,

  @JsonValue('ResponseParsingFailed')
  responseParsingFailed,

  @JsonValue('StoreProductNotAvailable')
  storeProductNotAvailable,

  @JsonValue('UnauthorizedRequestData')
  unauthorizedRequestData,

  @JsonValue('UnknownClientPlatform')
  unknownClientPlatform,
}

const _codes = {
  QErrorCode.unknown: 'Unknown',
  QErrorCode.apiRateLimitExceeded: 'ApiRateLimitExceeded',
  QErrorCode.appleStoreError: 'AppleStoreError',
  QErrorCode.backendError: 'BackendError',
  QErrorCode.billingUnavailable: 'BillingUnavailable',
  QErrorCode.clientInvalid: 'ClientInvalid',
  QErrorCode.cloudServiceNetworkConnectionFailed: 'CloudServiceNetworkConnectionFailed',
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

extension QErrorCodeExtension on QErrorCode {

  String get code {
    return _codes[this] ?? "Unknown";
  }
}