import '../permission.dart';
import '../product.dart';

class QMapper {
  static Map<String, QProduct> productsFromJson(dynamic json) {
    if (json == null) return <String, QProduct>{};

    final productsMap = Map<String, dynamic>.from(json);

    return productsMap.map((key, value) {
      final productMap = Map<String, dynamic>.from(value);
      return MapEntry(key, QProduct.fromJson(productMap));
    });
  }

  static Map<String, QPermission> permissionsFromJson(dynamic json) {
    if (json == null) return <String, QPermission>{};

    final permissionsMap = Map<String, dynamic>.from(json);

    return permissionsMap.map((key, value) {
      final permissionMap = Map<String, dynamic>.from(value);
      return MapEntry(key, QPermission.fromJson(permissionMap));
    });
  }

  static DateTime dateTimeFromSecondsTimestamp(double timestamp) {
    if (timestamp == null) return null;

    final intAbsTimestamp = timestamp.toInt().abs();
    return DateTime.fromMillisecondsSinceEpoch(intAbsTimestamp);
  }
}
