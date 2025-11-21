/// General Qonversion exception for all non-purchase related errors
class QonversionException implements Exception {
  /// Qonversion Error Code
  ///
  /// See more in [documentation](https://documentation.qonversion.io/docs/handling-errors)
  final String code;

  /// Error description
  final String message;

  /// Additional error info
  final String? details;

  const QonversionException(
    this.code,
    this.message,
    this.details,
  );

  @override
  String toString() {
    return 'QonversionException.\nCode: $code, Description: $message, Additional Message: $details';
  }
}

