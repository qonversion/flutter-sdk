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
    
    private func addAttributionData(args: [String: Any], _ result: @escaping FlutterResult) {
        guard let data = args["data"] as? [AnyHashable: Any] else {
            result(FlutterError.noData)
            return
        }
        
        guard let provider = args["provider"] as? String else {
            result(FlutterError.noProvider)
            return
        }
        
        guard let userId = args["userId"] as? String else {
            result(FlutterError.noUserId)
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
        
        Qonversion.addAttributionData(data, from: castedProvider, userID: userId)
        
        result(nil)
    }
}
