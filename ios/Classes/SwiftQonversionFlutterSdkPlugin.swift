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
            result(FlutterError.noArgs)
            return
        }
        
        guard let apiKey = args["key"] as? String, !apiKey.isEmpty else {
            result(FlutterError.noApiKey)
            return
        }
        
        switch call.method {
        case "launch":
            launch(with: apiKey, args, result)
            
        case "launchWithKeyCompletion":
            launch(with: apiKey, result)
            
        case "launchWithKeyUserId":
            guard let userID = args["userID"] as? String else {
                result(FlutterError.noUserId)
                return
            }
            
            launch(with: apiKey, userID: userID, result)
            
        case "launchWithKeyAutoTrackPurchasesCompletion":
            guard let autoTrackPurchases = args["autoTrackPurchases"] as? Bool else {
                result(FlutterError.noAutoTrackPurchases)
                return
            }
            
            launch(with: apiKey, autoTrackPurchases: autoTrackPurchases, result)
            
        case "addAttributionData":
            addAttributionData(args: args, result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func launch(with apiKey: String,
                        _ args: [String: Any],
                        _ result: @escaping FlutterResult) {
        let userId = args["userID"] as? String
        
        if let userId = userId {
            Qonversion.launch(withKey: apiKey, userID: userId)
            result(userId)
        } else {
            Qonversion.launch(withKey: apiKey) { uid in
                result(uid)
            }
        }
    }
    
    private func launch(with key: String, _ result: @escaping FlutterResult) {
        Qonversion.launch(withKey: key) { uid in
            result(uid)
        }
    }
    
    private func launch(with key: String, userID: String, _ result: @escaping FlutterResult) {
        Qonversion.launch(withKey: key, userID: userID)
        
        result(nil)
    }
    
    private func launch(with key: String, autoTrackPurchases: Bool, _ result: @escaping FlutterResult) {
        Qonversion.launch(withKey: key, autoTrackPurchases: autoTrackPurchases) { uid in
            result(uid)
        }
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
        var castedProvider = QAttributionProvider.appsFlyer
        
        switch provider {
        case "branch":
            castedProvider = QAttributionProvider.branch
        default:
            break
        }
        
        Qonversion.addAttributionData(data, from: castedProvider)
        
        result(nil)
    }
}
