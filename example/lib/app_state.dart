import 'package:flutter/foundation.dart';
import 'package:qonversion_flutter/qonversion_flutter.dart';

/// Global application state for the Qonversion SDK demo app
class AppState extends ChangeNotifier {
  // Initialization status
  bool _isInitialized = false;
  String _initStatus = 'not_initialized'; // not_initialized, initializing, success, error
  
  // Loading state
  bool _isLoading = false;
  
  // User info
  QUser? _userInfo;
  
  // Products and offerings
  Map<String, QProduct>? _products;
  QOfferings? _offerings;
  
  // Entitlements
  Map<String, QEntitlement>? _entitlements;
  
  // Remote configs
  QRemoteConfigList? _remoteConfigs;
  
  // User properties
  QUserProperties? _userProperties;
  
  // No-Codes events
  List<String> _noCodesEvents = [];
  
  // Getters
  bool get isInitialized => _isInitialized;
  String get initStatus => _initStatus;
  bool get isLoading => _isLoading;
  QUser? get userInfo => _userInfo;
  Map<String, QProduct>? get products => _products;
  QOfferings? get offerings => _offerings;
  Map<String, QEntitlement>? get entitlements => _entitlements;
  QRemoteConfigList? get remoteConfigs => _remoteConfigs;
  QUserProperties? get userProperties => _userProperties;
  List<String> get noCodesEvents => _noCodesEvents;
  
  // Setters with notification
  void setInitStatus(String status) {
    _initStatus = status;
    if (status == 'success') {
      _isInitialized = true;
    }
    notifyListeners();
  }
  
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void setUserInfo(QUser? user) {
    _userInfo = user;
    notifyListeners();
  }
  
  void setProducts(Map<String, QProduct>? products) {
    _products = products;
    notifyListeners();
  }
  
  void setOfferings(QOfferings? offerings) {
    _offerings = offerings;
    notifyListeners();
  }
  
  void setEntitlements(Map<String, QEntitlement>? entitlements) {
    _entitlements = entitlements;
    notifyListeners();
  }
  
  void setRemoteConfigs(QRemoteConfigList? configs) {
    _remoteConfigs = configs;
    notifyListeners();
  }
  
  void setUserProperties(QUserProperties? properties) {
    _userProperties = properties;
    notifyListeners();
  }
  
  void addNoCodesEvent(String event) {
    _noCodesEvents.insert(0, '${DateTime.now().toString().substring(11, 19)}: $event');
    if (_noCodesEvents.length > 50) {
      _noCodesEvents.removeLast();
    }
    notifyListeners();
  }
  
  void clearNoCodesEvents() {
    _noCodesEvents.clear();
    notifyListeners();
  }
}
