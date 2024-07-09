#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
#endif

import QonversionSandwich

public class SwiftQonversionPlugin: NSObject, FlutterPlugin {
  var updatedEntitlementsStreamHandler: BaseEventStreamHandler?
  var qonversionSandwich: QonversionSandwich?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger
    #if canImport(FlutterMacOS)
      messenger = registrar.messenger
    #else
      messenger = registrar.messenger()
    #endif
    let channel = FlutterMethodChannel(name: "qonversion_plugin", binaryMessenger: messenger)
    let instance = SwiftQonversionPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register updated entitlements events
    let updatedEntitlementsListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: "updated_entitlements")
    updatedEntitlementsListener.register() { instance.updatedEntitlementsStreamHandler = $0 }

    // Register sandwich
    let sandwichInstance = QonversionSandwich.init(qonversionEventListener: instance)
    instance.qonversionSandwich = sandwichInstance
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    // MARK: - Calls without arguments

    switch (call.method) {
    case "syncHistoricalData":
        qonversionSandwich?.syncHistoricalData()
        return result(nil)

    case "syncStoreKit2Purchases":
        qonversionSandwich?.syncStoreKit2Purchases()
        return result(nil)

    case "products":
      return products(result)

    case "checkEntitlements":
      return checkEntitlements(result)

    case "restore":
      return restore(result)

    case "collectAdvertisingId":
      qonversionSandwich?.collectAdvertisingId()
      return result(nil)

    case "offerings":
      return offerings(result)

    case "logout":
      qonversionSandwich?.logout()
      return result(nil)
    
    case "isFallbackFileAccessible":
      return isFallbackFileAccessible(result)

    case "userInfo":
      return userInfo(result)

    case "userProperties":
      return userProperties(result)

    case "remoteConfigList":
      return remoteConfigList(result)

    default:
      break
    }

    // MARK: - Calls with arguments

    guard let args = call.arguments as? [String: Any] else {
      return result(FlutterError.noNecessaryData)
    }

    switch call.method {
    case "initialize":
      return initialize(args, result)

    case "purchase":
      return purchase(args["productId"] as? String, result)

    case "remoteConfig":
      return remoteConfig(args["contextKey"] as? String, result)

    case "remoteConfigListForContextKeys":
      return remoteConfigList(args, result)

    case "setDefinedUserProperty":
      return setDefinedUserProperty(args, result)

    case "setCustomUserProperty":
      return setCustomUserProperty(args, result)

    case "addAttributionData":
      return addAttributionData(args, result)

    case "checkTrialIntroEligibility":
      return checkTrialIntroEligibility(args, result)

    case "storeSdkInfo":
      return storeSdkInfo(args, result)

    case "identify":
      return identify(args["userId"] as? String, result)
      
    case "attachUserToExperiment":
      return attachUserToExperiment(args, result)
      
    case "detachUserFromExperiment":
      return detachUserFromExperiment(args, result)

    case "attachUserToRemoteConfiguration":
      return attachUserToRemoteConfiguration(args, result)

    case "detachUserFromRemoteConfiguration":
      return detachUserFromRemoteConfiguration(args, result)

    default:
      return result(FlutterMethodNotImplemented)
    }
  }

  private func initialize(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let projectKey = args["projectKey"] as? String else {
      return result(FlutterError.noNecessaryData)
    }
    guard let launchMode = args["launchMode"] as? String else {
      return result(FlutterError.noNecessaryData)
    }
    let environment = args["environment"] as? String
    let entitlementsCacheLifetime = args["entitlementsCacheLifetime"] as? String
    let proxyUrl = args["proxyUrl"] as? String

    qonversionSandwich?.initialize(
      projectKey: projectKey,
      launchModeKey: launchMode,
      environmentKey: environment,
      entitlementsCacheLifetimeKey: entitlementsCacheLifetime,
      proxyUrl: proxyUrl
    )
  }

  private func identify(_ userId: String?, _ result: @escaping FlutterResult) {
    guard let userId = userId else {
      result(FlutterError.noNecessaryData)
      return
    }

    qonversionSandwich?.identify(userId, getDefaultCompletion(result))
  }

  private func products(_ result: @escaping FlutterResult) {
    qonversionSandwich?.products(getDefaultCompletion(result))
  }

  private func purchase(_ productId: String?, _ result: @escaping FlutterResult) {
    guard let productId = productId else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.purchase(productId, completion: getJsonCompletion(result))
  }

  private func checkEntitlements(_ result: @escaping FlutterResult) {
    qonversionSandwich?.checkEntitlements(getJsonCompletion(result))
  }

  private func remoteConfig(_ contextKey: String?, _ result: @escaping FlutterResult) {
    qonversionSandwich?.remoteConfig(contextKey, getJsonCompletion(result))
  }

  private func remoteConfigList(_ result: @escaping FlutterResult) {
    qonversionSandwich?.remoteConfigList(getJsonCompletion(result))
  }
  
  private func isFallbackFileAccessible(_ result: @escaping FlutterResult) {
    qonversionSandwich?.isFallbackFileAccessible(completion: getJsonCompletion(result))
  }

  private func remoteConfigList(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let contextKeys = args["contextKeys"] as? [String] else {
      return result(FlutterError.noNecessaryData)
    }

    guard let includeEmptyContextKey = args["includeEmptyContextKey"] as? Bool else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.remoteConfigList(contextKeys, includeEmptyContextKey:includeEmptyContextKey, getJsonCompletion(result))
  }

  private func userInfo(_ result: @escaping FlutterResult) {
    qonversionSandwich?.userInfo(getDefaultCompletion(result))
  }

  private func userProperties(_ result: @escaping FlutterResult) {
    qonversionSandwich?.userProperties(getJsonCompletion(result))
  }

  private func restore(_ result: @escaping FlutterResult) {
    qonversionSandwich?.restore(getJsonCompletion(result))
  }

  private func offerings(_ result: @escaping FlutterResult) {
    qonversionSandwich?.offerings(getJsonCompletion(result))
  }

  private func setDefinedUserProperty(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let rawProperty = args["property"] as? String else {
      return result(FlutterError.noNecessaryData)
    }

    guard let value = args["value"] as? String else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.setDefinedProperty(rawProperty, value: value)
    result(nil)
  }

  private func setCustomUserProperty(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let property = args["property"] as? String else {
      return result(FlutterError.noNecessaryData)
    }

    guard let value = args["value"] as? String else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.setCustomProperty(property, value: value)
    result(nil)
  }

  private func checkTrialIntroEligibility(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let ids = args["ids"] as? [String] else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.checkTrialIntroEligibility(ids, completion: getJsonCompletion(result))
  }

  private func storeSdkInfo(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let version = args["version"] as? String,
        let source = args["source"] as? String
    else {
        return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.storeSdkInfo(source: source, version: version)
    result(nil)
  }

  private func addAttributionData(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let data = args["data"] as? [String: Any] else {
      return result(FlutterError.noNecessaryData)
    }

    guard let provider = args["provider"] as? String else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.attribution(providerKey: provider, value: data)
    result(nil)
  }
  
  private func attachUserToExperiment(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let experimentId = args["experimentId"] as? String,
          let groupId = args["groupId"] as? String else {
      return result(FlutterError.noNecessaryData)
    }
    
    qonversionSandwich?.attachUserToExperiment(with: experimentId, groupId: groupId, completion: getJsonCompletion(result))
  }
  
  private func detachUserFromExperiment(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let experimentId = args["experimentId"] as? String else {
      return result(FlutterError.noNecessaryData)
    }
    
    qonversionSandwich?.detachUserFromExperiment(with: experimentId, completion: getJsonCompletion(result))
  }

  private func attachUserToRemoteConfiguration(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let remoteConfigurationId = args["remoteConfigurationId"] as? String else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.attachUserToRemoteConfiguration(with: remoteConfigurationId, completion: getJsonCompletion(result))
  }

  private func detachUserFromRemoteConfiguration(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let remoteConfigurationId = args["remoteConfigurationId"] as? String else {
      return result(FlutterError.noNecessaryData)
    }

    qonversionSandwich?.detachUserFromRemoteConfiguration(with: remoteConfigurationId, completion: getJsonCompletion(result))
  }
  
  private func getDefaultCompletion(_ result: @escaping FlutterResult) -> BridgeCompletion {
    return { data, error in
      if let error = error {
        return result(FlutterError.sandwichError(error))
      }

      result(data)
    }
  }

  private func getJsonCompletion(_ result: @escaping FlutterResult) -> BridgeCompletion {
    return { data, error in
      if let error = error {
        return result(FlutterError.sandwichError(error))
      }

      guard let data = data else {
        return result(nil)
      }

      guard let jsonData = data.toJson() else {
        return result(FlutterError.serializationError)
      }

      result(jsonData)
    }
  }
}

extension SwiftQonversionPlugin: QonversionEventListener {
  public func qonversionDidReceiveUpdatedEntitlements(_ entitlements: [String : Any]) {
    guard let jsonData = entitlements.toJson() else {
      return
    }
    updatedEntitlementsStreamHandler?.eventSink?(jsonData)
  }

  public func shouldPurchasePromoProduct(with productId: String) {
    // Promo purchases are not supported on MacOS.
  }
}
