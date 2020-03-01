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
        guard let args = call.arguments as? [String: Any] else {
                return result("Could not find call arguments. Make sure you pass Map as call arguments")
        }
        switch call.method {
        case "launchWithKeyCompletion":
            guard let key = args["key"] as? String else {
                return result("Could not find API key, please make sure you pass a valid value")
            }
            return launch(with: key, result)
        case "launchWithKeyUserId":
            guard let key = args["key"] as? String, let userID = args["userID"] as? String else {
                return result("Could not find either API key or userID, please make sure you pass a valid value")
            }
            return launch(with: key, userID: userID, result)
        case "launchWithKeyAutoTrackPurchasesCompletion":
            guard let key = args["key"] as? String, let autoTrackPurchases = args["autoTrackPurchases"] as? Bool else {
                    return result("Could not find either key or autoTrackPurchases boolean value, make sure you pass it as a {\"autoTrackPurchases\": autoTrackPurchases} key-value pair to call arguments")
            }
            return launch(with: key, autoTrackPurchases: autoTrackPurchases, result)
        case "addAttributionData":
            return addAttributionData(args: args, result)
        default:
            return result(FlutterMethodNotImplemented)
        }
    }
    
    private func launch(with key: String, _ result: @escaping FlutterResult) {
        Qonversion.launch(withKey: key) { uid in
            return result(uid)
        }
    }
    
    private func launch(with key: String, userID: String, _ result: @escaping FlutterResult) {
        return result(Qonversion.launch(withKey: key, userID: userID))
    }
    
    private func launch(with key: String, autoTrackPurchases: Bool, _ result: @escaping FlutterResult) {
        return Qonversion.launch(withKey: key, autoTrackPurchases: autoTrackPurchases) { uid in
            return result(uid)
        }
    }
    
    private func addAttributionData(args: [String: Any], _ result: @escaping FlutterResult) {
        guard let data = args["data"] as? [AnyHashable: Any], let provider = args["provider"] as? String else {
            return
        }
        // Using appsFlyer by default since there are only 2 cases in an enum yet.
        var castedProvider = QAttributionProvider.appsFlyer
        
        switch provider {
        case "branch":
            castedProvider = QAttributionProvider.branch
        default:
            break
        }
        
        let userId = args["userID"] as? String
        
        return result(Qonversion.addAttributionData(data, from: castedProvider, userID: userId))
    }
}
