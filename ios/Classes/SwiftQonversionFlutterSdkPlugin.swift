import Flutter
import UIKit
import Qonversion

public class SwiftQonversionFlutterSdkPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "qonversion_flutter_sdk", binaryMessenger: registrar.messenger())
    
    let instance = SwiftQonversionFlutterSdkPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)

    Qonversion.setPurchasesDelegate(instance)
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
      Qonversion.setDebugMode()
      return result(nil)
      
    case "offerings":
      return offerings(result)
      
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
      
    case "setUserId":
      return setUserId(args["userId"] as? String, result)
      
    case "addAttributionData":
      return addAttributionData(args, result)
      
    case "setProperty":
      return setProperty(args, result)
      
    case "setUserProperty":
      return setUserProperty(args, result)
      
    case "checkTrialIntroEligibility":
      return checkTrialIntroEligibility(args, result)
      
    default:
      return result(FlutterMethodNotImplemented)
    }
  }
  
  private func launch(with apiKey: String?, _ result: @escaping FlutterResult) {
    guard let apiKey = apiKey, !apiKey.isEmpty else {
      return result(FlutterError.noApiKey)
    }
    
    Qonversion.launch(withKey: apiKey) { launchResult, error in
      if let error = error {
        return result(FlutterError.qonversionError(error.localizedDescription))
      }
      
      let resultMap = launchResult.toMap()
      result(resultMap)
    }
  }
  
  private func products(_ result: @escaping FlutterResult) {
    Qonversion.products { (products, error) in
      if let error = error {
        return result(FlutterError.failedToGetProducts(error.localizedDescription))
      }
      
      let productsMap = products.mapValues { $0.toMap() }
      
      result(productsMap)
    }
  }
  
  private func purchase(_ productId: String?, _ result: @escaping FlutterResult) {
    guard let productId = productId else {
      return result(FlutterError.noProductId)
    }
    
    Qonversion.purchase(productId) { (permissions, error, isCancelled) in
      let purchaseResult = PurchaseResult(permissions: permissions,
                                          error: error,
                                          isCancelled: isCancelled)
      result(purchaseResult.toMap())
    }
  }
  
  private func checkPermissions(_ result: @escaping FlutterResult) {
    Qonversion.checkPermissions { (permissions, error) in
      if let error = error {
        return result(FlutterError.qonversionError(error.localizedDescription))
      }
      
      let permissionsDict = permissions.mapValues { $0.toMap() }
      result(permissionsDict)
    }
  }
  
  private func restore(_ result: @escaping FlutterResult) {
    Qonversion.restore { (permissions, error) in
      if let error = error {
        return result(FlutterError.qonversionError(error.localizedDescription))
      }
      
      let permissionsDict = permissions.mapValues { $0.toMap() }
      result(permissionsDict)
    }
  }
  
  private func offerings(_ result: @escaping FlutterResult) {
    Qonversion.offerings { offerings, error in
      if let error = error {
        result(FlutterError.offeringsError(error.localizedDescription))
      }
      
      guard let offerings = offerings else {
        return result(nil)
      }
      
      
      result(offerings.toMap().toJson())
    }
  }
  
  private func setUserId(_ userId: String?, _ result: @escaping FlutterResult) {
    guard let userId = userId else {
      result(FlutterError.noUserId)
      return
    }
    
    Qonversion.setUserID(userId)
    result(nil)
  }
  
  private func setProperty(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let rawProperty = args["property"] as? String else {
      return result(FlutterError.noData)
    }
    
    guard let value = args["value"] as? String else {
      return result(FlutterError.noProvider)
    }
    
    do {
      let property = try Qonversion.Property.fromString(rawProperty)
      
      Qonversion.setProperty(property, value: value)
      result(nil)
    } catch ParsingError.runtimeError(let message) {
      result(FlutterError.parsingError(message))
    } catch {
      result(FlutterError.qonversionError(error.localizedDescription))
    }
  }
    
  private func setUserProperty(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let property = args["property"] as? String else {
      return result(FlutterError.noData)
    }
    
    guard let value = args["value"] as? String else {
      return result(FlutterError.noProvider)
    }
    
    Qonversion.setUserProperty(property, value: value)
    
    result(nil)
  }
  
  private func checkTrialIntroEligibility(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let ids = args["ids"] as? [String] else {
      return result(FlutterError.noData)
    }
    
    Qonversion.checkTrialIntroEligibility(forProductIds: ids) { eligibilities, error in
      if let error = error {
        return result(FlutterError.qonversionError(error.localizedDescription))
      }
      
      result(eligibilities.mapValues { $0.toMap() }.toJson())
    }
  }
  
  private func addAttributionData(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let data = args["data"] as? [AnyHashable: Any] else {
      return result(FlutterError.noData)
    }
    
    guard let provider = args["provider"] as? String else {
      return result(FlutterError.noProvider)
    }
    
    // Using appsFlyer by default since there are only 2 cases in an enum yet.
    var castedProvider = Qonversion.AttributionProvider.appsFlyer
    
    switch provider {
    case "branch":
      castedProvider = Qonversion.AttributionProvider.branch
    default:
      break
    }
    
    Qonversion.addAttributionData(data, from: castedProvider)
    
    result(nil)
  }
        
}

// MARK: - Qonversion.PurchasesDelegate

extension SwiftQonversionFlutterSdkPlugin: Qonversion.PurchasesDelegate {
    static private let pendingPurchasesUpdated = "pendingPurchasesUpdated"

    public func qonversionDidReceiveUpdatedPermissions(_ permissions: [String : Qonversion.Permission]) {
        self.channel?.invokeMethod(SwiftQonversionFlutterSdkPlugin.pendingPurchasesUpdated, arguments: permissions.mapValues { $0.toMap() })
    }
}
