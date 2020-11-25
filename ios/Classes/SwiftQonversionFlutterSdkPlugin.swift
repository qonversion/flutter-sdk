import Flutter
import UIKit
import Qonversion

public class SwiftQonversionFlutterSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "qonversion_flutter_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftQonversionFlutterSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    // MARK: - Calls without arguments
    
    switch (call.method) {
    case "products":
      return products(result)
    default:
      break
    }
    
    // MARK: - Calls with arguments
    
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError.noArgs)
      return
    }
    
    switch call.method {
    case "launch":
      return launch(with: args["key"] as? String, result)
      
    case "setUserId":
      return setUserId(args["userId"] as? String, result)
      
    case "addAttributionData":
      return addAttributionData(args: args, result)
      
    default:
      return result(FlutterMethodNotImplemented)
    }
  }
  
  private func launch(with apiKey: String?, _ result: @escaping FlutterResult) {
    guard let apiKey = apiKey, !apiKey.isEmpty else {
      result(FlutterError.noApiKey)
      return
    }
    
    Qonversion.launch(withKey: apiKey) { launchResult, error in
      if let error = error {
        result(FlutterError.failedToLaunchSdk(error.localizedDescription))
        return
      }
      result(launchResult.toMap())
    }
  }
  
  private func products(_ result: @escaping FlutterResult) {
    Qonversion.products { (products, error) in
      if let error = error {
        result(FlutterError.failedToGetProducts(error.localizedDescription))
        return
      }
      
      let productsMap = products.mapValues { $0.toMap() }
      
      result(productsMap)
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
  
  private func addAttributionData(args: [String: Any], _ result: @escaping FlutterResult) {
    guard let data = args["data"] as? [AnyHashable: Any] else {
      result(FlutterError.noData)
      return
    }
    
    guard let provider = args["provider"] as? String else {
      result(FlutterError.noProvider)
      return
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
