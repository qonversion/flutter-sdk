class QPurchaseException implements Exception {
  /// Qonversion Error Code
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/handling-errors)
  final String code;

  /// Error description
  final String message;

  /// Additional error info
  final String? additionalMessage;

  /// `true` if user explicitly cancelled purchasing process.
  final bool isUserCancelled;

  const QPurchaseException(
    this.code,
    this.message,
    this.additionalMessage, {
    required this.isUserCancelled,
  });

  @override
  String toString() {
    return 'QPurchaseException.\nCode: $code, Description: $message, Additional Message: $additionalMessage, isUserCancelled: $isUserCancelled';
  }
}
