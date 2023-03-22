#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
#endif

import QonversionSandwich

public class SwiftQonversionPlugin: NSObject, FlutterPlugin {
  var updatedEntitlementsStreamHandler: BaseEventStreamHandler?
  var promoPurchasesStreamHandler: BaseEventStreamHandler?
  var qonversionSandwich: QonversionSandwich?
  private var automationsPlugin: AutomationsPlugin?
  
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
    
    // Register promo purchases events
    let promoPurchasesListener = FlutterListenerWrapper<BaseEventStreamHandler>(registrar, postfix: "promo_purchases")
    promoPurchasesListener.register() { instance.promoPurchasesStreamHandler = $0 }

    // Register sandwich
    let sandwichInstance = QonversionSandwich.init(qonversionEventListener: instance)
    instance.qonversionSandwich = sandwichInstance
    
    instance.automationsPlugin = AutomationsPlugin()
    instance.automationsPlugin?.register(registrar)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    // MARK: - Calls without arguments
    
    switch (call.method) {
    case "syncHistoricalData":
        qonversionSandwich?.syncHistoricalData()
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
      
    case "userInfo":
      qonversionSandwich?.userInfo(getDefaultCompletion(result))
      return result(nil)

    case "presentCodeRedemptionSheet":
      return presentCodeRedemptionSheet(result)

    case "collectAppleSearchAdsAttribution":
      return collectAppleSearchAdsAttribution(result)

    case "automationsSubscribe":
      automationsPlugin?.subscribe()
      return result(nil)
      
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
      
    case "purchaseProduct":
      return purchaseProduct(args["productId"] as? String, args["offeringId"] as? String, result)
      
    case "promoPurchase":
      return promoPurchase(args["productId"] as? String, result)
      
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

    case "automationsSetNotificationsToken":
      automationsPlugin?.setNotificationsToken(args["notificationsToken"] as? String, result)
      return
      
    case "automationsHandleNotification":
      automationsPlugin?.handleNotification(args, result)
      return
      
    case "automationsGetNotificationCustomPayload":
      automationsPlugin?.getNotificationCustomPayload(args, result)
      return
      
    case "automationsShowScreen":
      automationsPlugin?.showScreen(args["screenId"] as? String, result)
      return

    case "setScreenPresentationConfig":
      automationsPlugin?.setScreenPresentationConfig(args["configData"] as? [String: Any], args["screenId"] as? String, result)
      return

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
    
    qonversionSandwich?.identify(userId)
    result(nil)
  }

  private func products(_ result: @escaping FlutterResult) {
    qonversionSandwich?.products(getDefaultCompletion(result))
  }
  
  private func purchase(_ productId: String?, _ result: @escaping FlutterResult) {
    guard let productId = productId else {
      return result(FlutterError.noNecessaryData)
    }
    
    qonversionSandwich?.purchase(productId, completion: getPurchaseCompletion(result))
  }
  
  private func purchaseProduct(_ productId: String?, _ offeringId: String?, _ result: @escaping FlutterResult) {
    guard let productId = productId else {
      return result(FlutterError.noNecessaryData)
    }
    
    qonversionSandwich?.purchaseProduct(productId, offeringId: offeringId, completion: getPurchaseCompletion(result))
  }
  
  private func promoPurchase(_ productId: String?, _ result: @escaping FlutterResult) {
    guard let productId = productId else {
      return result(FlutterError.noNecessaryData)
    }
    
    qonversionSandwich?.promoPurchase(productId, completion: getPurchaseCompletion(result))
  }
  
  private func checkEntitlements(_ result: @escaping FlutterResult) {
    qonversionSandwich?.checkEntitlements(getDefaultCompletion(result))
  }
  
  private func restore(_ result: @escaping FlutterResult) {
    qonversionSandwich?.restore(getDefaultCompletion(result))
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
  
  private func collectAppleSearchAdsAttribution(_ result: @escaping FlutterResult) {
    qonversionSandwich?.collectAppleSearchAdsAttribution()
    result(nil)
  }

  private func presentCodeRedemptionSheet(_ result: @escaping FlutterResult) {
    if #available(iOS 14.0, *) {
      qonversionSandwich?.presentCodeRedemptionSheet()
    }
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

extension SwiftQonversionPlugin: QonversionEventListener {
  public func qonversionDidReceiveUpdatedEntitlements(_ entitlements: [String : Any]) {
    guard let jsonData = entitlements.toJson() else {
      return
    }
    updatedEntitlementsStreamHandler?.eventSink?(jsonData)
  }
  
  public func shouldPurchasePromoProduct(with productId: String) {
    promoPurchasesStreamHandler?.eventSink?(productId)
  }
}
