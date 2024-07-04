import 'package:json_annotation/json_annotation.dart';

enum QErrorCode {
  /// Unknown error
  @JsonValue('Unknown')
  unknown,

  /// API requests rate limit exceeded
  @JsonValue('ApiRateLimitExceeded')
  apiRateLimitExceeded,

  /// Apple Store error received
  @JsonValue('AppleStoreError')
  appleStoreError,

  /// There was a backend error
  @JsonValue('BackendError')
  backendError,

  /// The Billing service is unavailable on the device
  @JsonValue('BillingUnavailable')
  billingUnavailable,

  /// Client is not allowed to issue the request, etc
  @JsonValue('ClientInvalid')
  clientInvalid,

  /// The device could not connect to the network
  @JsonValue('CloudServiceNetworkConnectionFailed')
  cloudServiceNetworkConnectionFailed,

  /// User is not allowed to access cloud service information
  @JsonValue('CloudServicePermissionDenied')
  cloudServicePermissionDenied,

  /// User has revoked permission to use this cloud service
  @JsonValue('CloudServiceRevoked')
  cloudServiceRevoked,

  /// Could not receive data
  @JsonValue('FailedToReceiveData')
  failedToReceiveData,

  /// The requested feature is not supported
  @JsonValue('FeatureNotSupported')
  featureNotSupported,



  /// Fraud purchase was detected
  @JsonValue('FraudPurchase')
  fraudPurchase,

  /// Request failed
  @JsonValue('IncorrectRequest')
  incorrectRequest,

  /// Internal backend error
  @JsonValue('InternalError')
  internalError,

  /// Client Uid is invalid or not set
  @JsonValue('InvalidClientUid')
  invalidClientUid,

  /// Access token is invalid or not set
  @JsonValue('InvalidCredentials')
  invalidCredentials,

  /// This account does not have access to the requested application
  @JsonValue('InvalidStoreCredentials')
  invalidStoreCredentials,

  /// There was an error while launching Qonversion SDK
  @JsonValue('LaunchError')
  launchError,

  /// There was a network issue. Make sure that the Internet connection is available on the device
  @JsonValue('NetworkConnectionFailed')
  networkConnectionFailed,

  /// No offerings found
  @JsonValue('OfferingsNotFound')
  offeringsNotFound,

  /// Purchase identifier was invalid, etc.
  @JsonValue('PaymentInvalid')
  paymentInvalid,

  /// This device is not allowed to make the payment
  @JsonValue('PaymentNotAllowed')
  paymentNotAllowed,

  /// There was an issue with the Play Store service
  @JsonValue('PlayStoreError')
  playStoreError,

  /// User needs to acknowledge Apple's privacy policy
  @JsonValue('PrivacyAcknowledgementRequired')
  privacyAcknowledgementRequired,

  /// Failed to purchase since item is already owned
  @JsonValue('ProductAlreadyOwned')
  productAlreadyOwned,

  /// Failed to purchase since the Qonversion product was not found
  @JsonValue('ProductNotFound')
  productNotFound,

  /// Failed to consume purchase since item is not owned
  @JsonValue('ProductNotOwned')
  productNotOwned,

  /// The project is not configured or configured incorrectly in the Qonversion Dashboard
  @JsonValue('ProjectConfigError')
  projectConfigError,

  /// User pressed back or canceled a dialog for purchase
  @JsonValue('PurchaseCanceled')
  purchaseCanceled,

  /// Failure of purchase
  @JsonValue('PurchaseInvalid')
  purchaseInvalid,

  /// Purchase is pending
  @JsonValue('PurchasePending')
  purchasePending,

  /// Unspecified state of the purchase
  @JsonValue('PurchaseUnspecified')
  purchaseUnspecified,

  /// Receipt validation error
  @JsonValue('ReceiptValidationError')
  receiptValidationError,

  /// Remote configuration is not available for the current user or for the provided context key
  @JsonValue('RemoteConfigurationNotAvailable')
  remoteConfigurationNotAvailable,

  /// A problem occurred while serializing or deserializing data
  @JsonValue('ResponseParsingFailed')
  responseParsingFailed,

  /// Requested product is not available for purchase or its product id was not found
  @JsonValue('StoreProductNotAvailable')
  storeProductNotAvailable,

  /// App is attempting to use SKPayment's requestData property, but does not have the appropriate entitlement
  @JsonValue('UnauthorizedRequestData')
  unauthorizedRequestData,

  /// The current platform is not supported
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