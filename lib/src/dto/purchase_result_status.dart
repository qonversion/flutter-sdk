/// Status of the purchase result.
enum QPurchaseResultStatus {
  /// The purchase was successful.
  success,

  /// The purchase was canceled by the user.
  userCanceled,

  /// The purchase is pending (e.g., waiting for parental approval).
  pending,

  /// An error occurred during the purchase.
  error,
}
