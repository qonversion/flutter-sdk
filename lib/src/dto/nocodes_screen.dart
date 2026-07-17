/// Kind of a No-Codes screen default variable — what it was configured as in the builder.
/// The set may grow in future backend versions; values this SDK version does not know
/// are mapped to [QScreenVariableKind.unknown] instead of failing.
enum QScreenVariableKind {
  /// A Screen Variable authored in the builder's Variables section.
  custom,

  /// A product slot: the variable key is the slot name and the value is the default
  /// Qonversion product id assigned to it.
  product,

  /// The screen's Default Product configured in the builder: the value is
  /// the Qonversion product id selected by default.
  selectedProduct,

  /// A kind introduced on the backend after this SDK version was released.
  unknown,
}

QScreenVariableKind _screenVariableKindFromKey(String? key) {
  switch (key) {
    case 'custom':
      return QScreenVariableKind.custom;
    case 'product':
      return QScreenVariableKind.product;
    case 'selected_product':
      return QScreenVariableKind.selectedProduct;
    default:
      return QScreenVariableKind.unknown;
  }
}

/// A typed default variable of a No-Codes screen, configured in the builder and delivered
/// at screen load so it can be read by key. The value keeps its authored type
/// (bool / String / num) rather than being coerced to a string.
class QScreenVariable {
  /// What the variable represents — see [QScreenVariableKind].
  final QScreenVariableKind kind;

  /// Variable name it is addressed by (`variable.<key>` in the builder for custom
  /// variables, the slot name for product slots). May contain spaces.
  final String key;

  /// Authored value type: `"boolean"`, `"string"` or `"number"`.
  final String type;

  /// The configured default value, preserving its native type
  /// (bool / String / double). Numbers are always [double].
  /// Null when no default value was authored.
  final Object? value;

  /// The value rendered as a plain string regardless of its native type: `"true"`/`"false"`
  /// for booleans, the string itself, a number without a trailing `.0` when integral,
  /// or an empty string when no value was authored.
  final String stringValue;

  const QScreenVariable({
    required this.kind,
    required this.key,
    required this.type,
    required this.value,
    required this.stringValue,
  });

  factory QScreenVariable.fromMap(Map<String, dynamic> map) {
    final rawValue = map['value'];
    // The Android bridge serializes numbers as double while iOS emits integral
    // numbers as int — normalize so numeric values always come as double.
    final value = rawValue is int ? rawValue.toDouble() : rawValue;
    return QScreenVariable(
      kind: _screenVariableKindFromKey(map['kind'] as String?),
      key: map['key'] as String? ?? '',
      type: map['type'] as String? ?? '',
      value: value,
      stringValue: map['stringValue'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'QScreenVariable(kind: $kind, key: $key, type: $type, value: $value, stringValue: $stringValue)';
  }
}

/// A loaded No-Codes screen returned from [NoCodes.loadScreen].
///
/// Exposes the screen identifiers and the typed default variables configured in the builder —
/// the screen content stays internal, as rendering remains the SDK's job via
/// [NoCodes.showScreen].
class QNoCodeScreen {
  /// Identifier of the screen.
  final String id;

  /// The context key of the screen set in the No-Codes builder.
  final String contextKey;

  /// The Qonversion product id selected by default when the screen opens (the builder's
  /// Default Product), or null when none is configured.
  final String? defaultSelectedProductId;

  /// Typed default variables of the screen configured in the builder: authored custom
  /// variables and product slots. Read them by [QScreenVariable.key] (may be empty).
  final List<QScreenVariable> defaultVariables;

  const QNoCodeScreen({
    required this.id,
    required this.contextKey,
    this.defaultSelectedProductId,
    this.defaultVariables = const [],
  });

  factory QNoCodeScreen.fromMap(Map<String, dynamic> map) {
    final rawVariables = map['defaultVariables'] as List<dynamic>? ?? [];
    return QNoCodeScreen(
      id: map['id'] as String? ?? '',
      contextKey: map['contextKey'] as String? ?? '',
      defaultSelectedProductId: map['defaultSelectedProductId'] as String?,
      defaultVariables: rawVariables
          .whereType<Map<dynamic, dynamic>>()
          .map((variable) => QScreenVariable.fromMap(Map<String, dynamic>.from(variable)))
          .toList(),
    );
  }

  /// Returns the default variable configured under the given [key], or null when the screen
  /// has no variable with that exact (case-sensitive) key.
  ///
  /// Keys are only unique within a kind — a custom variable and a product slot may share
  /// a name — so pass [kind] to disambiguate; without it the first match in payload order
  /// (custom variables, then product slots, then the selected product) is returned.
  ///
  /// For the default selected product prefer [defaultSelectedProductId] — it needs no key.
  QScreenVariable? defaultVariable(String key, {QScreenVariableKind? kind}) {
    for (final variable in defaultVariables) {
      if (variable.key == key && (kind == null || variable.kind == kind)) {
        return variable;
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'QNoCodeScreen(id: $id, contextKey: $contextKey, '
        'defaultSelectedProductId: $defaultSelectedProductId, defaultVariables: $defaultVariables)';
  }
}
