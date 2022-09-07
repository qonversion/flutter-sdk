#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
#endif

import QonversionSandwich

public class SwiftQonversionFlutterSdkPlugin: NSObject, FlutterPlugin {
  var deferredPurchasesStreamHandler: BaseEventStreamHandler?
  var qonversionSandwich: QonversionSandwich?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger: FlutterBinaryMessenger
    #if canImport(FlutterMacOS)
      messenger = registrar.messenger
    #else
      messenger = registrar.messenger()
    #endif
    let channel = FlutterMethodChannel(name: "qonversion_flutter_sdk", binaryMessenger: messenger)
    let instance = SwiftQonversionFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    // Register deferred purchases events
    let purchasesListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: "updated_purchases")
    purchasesListener.register() { instance.deferredPurchasesStreamHandler = $0 }

    // Register sandwich
    let sandwichInstance = QonversionSandwich.init(qonversionEventListener: instance)
    instance.qonversionSandwich = sandwichInstance
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    // MARK: - Calls without arguments

    switch (call.method) {
    case "products":
      return products(result)

    case "checkPermissions":
      return checkPermissions(result)

    case "restore":
      return restore(result)

    case "setDebugMode":
      qonversionSandwich?.setDebugMode()
      return result(nil)

    case "setAdvertisingID":
      qonversionSandwich?.setAdvertisingId()
      return result(nil)

    case "offerings":
      return offerings(result)

    case "logout":
      qonversionSandwich?.logout()
      return result(nil)

    default:
      break
    }

    // MARK: - Calls with arguments

    guard let args = call.arguments as? [String: Any] else {
      return result(FlutterError.noArgs)
    }

    switch call.method {
    case "launch":
      return launch(with: args["key"] as? String, result)

    case "purchase":
      return purchase(args["productId"] as? String, result)

    case "purchaseProduct":
      return purchaseProduct(args["productId"] as? String, args["offeringId"] as? String, result)

    case "addAttributionData":
      return addAttributionData(args, result)

    case "setDefinedUserProperty":
      return setDefinedUserProperty(args, result)

    case "setCustomUserProperty":
      return setCustomUserProperty(args, result)

    case "checkTrialIntroEligibility":
      return checkTrialIntroEligibility(args, result)

    case "storeSdkInfo":
      return storeSdkInfo(args, result)

    case "identify":
        return identify(args["userId"] as? String, result)

    case "setPermissionsCacheLifetime":
      return setPermissionsCacheLifetime(args, result)

    default:
      return result(FlutterMethodNotImplemented)
    }
  }

  private func launch(with apiKey: String?, _ result: @escaping FlutterResult) {
    guard let apiKey = apiKey, !apiKey.isEmpty else {
      return result(FlutterError.noApiKey)
    }

    qonversionSandwich?.launch(projectKey: apiKey, completion: getDefaultCompletion(result))
  }

  private func identify(_ userId: String?, _ result: @escaping FlutterResult) {
    guard let userId = userId else {
      result(FlutterError.noUserId)
      return
    }

    qonversionSandwich?.identify(userId)
    result(nil)
  }

  private func products(_ result: @escaping FlutterResult) {
    qonversionSandwich?.products({ products, error in
      if let error = error {
        return result(FlutterError.failedToGetProducts(error))
      }

      result(products)
    })
  }

  private func purchase(_ productId: String?, _ result: @escaping FlutterResult) {
    guard let productId = productId else {
      return result(FlutterError.noProductId)
    }

    qonversionSandwich?.purchase(productId, completion: getPurchaseCompletion(result))
  }

  private func purchaseProduct(_ productId: String?, _ offeringId: String?, _ result: @escaping FlutterResult) {
    guard let productId = productId else {
      return result(FlutterError.noProductId)
    }
    guard let offeringId = offeringId else {
      return result(FlutterError.noOfferingId)
    }

    qonversionSandwich?.purchaseProduct(productId, offeringId, completion: getPurchaseCompletion(result))
  }

  private func checkPermissions(_ result: @escaping FlutterResult) {
    qonversionSandwich?.checkPermissions(getDefaultCompletion(result))
  }

  private func restore(_ result: @escaping FlutterResult) {
    qonversionSandwich?.restore(getDefaultCompletion(result))
  }

  private func offerings(_ result: @escaping FlutterResult) {
    qonversionSandwich?.offerings(getJsonCompletion(result))
  }

  private func setDefinedUserProperty(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let rawProperty = args["property"] as? String else {
      return result(FlutterError.noProperty)
    }

    guard let value = args["value"] as? String else {
      return result(FlutterError.noPropertyValue)
    }

    qonversionSandwich?.setDefinedProperty(rawProperty, value: value)
    result(nil)
  }

  private func setCustomUserProperty(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let property = args["property"] as? String else {
      return result(FlutterError.noProperty)
    }

    guard let value = args["value"] as? String else {
      return result(FlutterError.noPropertyValue)
    }

    qonversionSandwich?.setCustomProperty(property, value: value)
    result(nil)
  }

  private func checkTrialIntroEligibility(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let ids = args["ids"] as? [String] else {
      return result(FlutterError.noData)
    }

    qonversionSandwich?.checkTrialIntroEligibility(ids, completion: getJsonCompletion(result))
  }

  private func storeSdkInfo(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let version = args["version"] as? String,
        let source = args["source"] as? String
    else {
        return result(FlutterError.noSdkInfo)
    }

    qonversionSandwich?.storeSdkInfo(source: source, version: version)
    result(nil)
  }

  private func addAttributionData(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let data = args["data"] as? [String: Any] else {
      return result(FlutterError.noData)
    }

    guard let provider = args["provider"] as? String else {
      return result(FlutterError.noProvider)
    }

    qonversionSandwich?.addAttributionData(sourceKey: provider, value: data)
    result(nil)
  }

  private func setPermissionsCacheLifetime(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let rawLifetime = args["lifetime"] as? String else {
      return result(FlutterError.noLifetime)
    }

    qonversionSandwich?.setPermissionsCacheLifetime(rawLifetime)
    result(nil)
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

  private func getPurchaseCompletion(_ result: @escaping FlutterResult) -> BridgeCompletion {
    return { data, error in
      if let error = error {
        return result(FlutterError.purchaseError(error))
      }

      result(data)
    }
  }
}

extension SwiftQonversionFlutterSdkPlugin: QonversionEventListener {
  public func shouldPurchasePromoProduct(with productId: String) {
    // Promo purchases are not supported.
  }

  public func qonversionDidReceiveUpdatedPermissions(_ permissions: [String : Any]) {
    deferredPurchasesStreamHandler?.eventSink?(permissions)
  }
}
