class QPurchaseException implements Exception {
  final String message;

  /// Makes sense on iOS only.
  ///
  /// `true` if user explicitly cancelled purchasing process.
  final bool isUserCancelled;

  const QPurchaseException(
    this.message, {
    required this.isUserCancelled,
  });

  @override
  String toString() {
    return 'QPurchaseException.\nMessage: $message, isUserCancelled: $isUserCancelled';
  }
}
