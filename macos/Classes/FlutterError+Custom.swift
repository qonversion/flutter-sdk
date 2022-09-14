//
//  FlutterError+Custom.swift
//  Pods-Runner
//
//  Created by Ilya Virnik on 6/21/20.
//

#if canImport(FlutterMacOS)
import FlutterMacOS
#else
import Flutter
#endif

import QonversionSandwich

extension FlutterError {
  static private let passValidValue = "Please make sure you pass a valid value"
  
  static let noArgs = FlutterError(code: "0",
                                   message: "Could not find call arguments",
                                   details: "Make sure you pass Map as call arguments")
  
  static let noApiKey = FlutterError(code: "1",
                                     message: "Could not find API key",
                                     details: passValidValue)
  
  static let noUserId = FlutterError(code: "2",
                                     message: "Could not find userID",
                                     details: passValidValue)
  
  static let noData = FlutterError(code: "4",
                                   message: "Could not find data",
                                   details: passValidValue)
  
  static let noProvider = FlutterError(code: "5",
                                       message: "Could not find provider",
                                       details: passValidValue)
  
  static func failedToGetProducts(_ error: SandwichError) -> FlutterError {
    return mapSandwichError(error, errorCode: "7", errorMessage: "Failed to get products")
  }
  
  static let noProductId = FlutterError(code: "8",
                                        message: "Could not find productId value",
                                        details: "Please provide valid productId")

  static func sandwichError(_ error: SandwichError) -> FlutterError {
    return mapSandwichError(error, errorCode: "9")
  }
  
  static func purchaseError(_ error: SandwichError) -> FlutterError {
    let isCancelled = error.additionalInfo["isCancelled"]
    let code = isCancelled != nil ? "PurchaseCancelledByUser" : "9"
    return mapSandwichError(error, errorCode: code)
  }
  
  static let noProperty = FlutterError(code: "13",
                                       message: "Could not find property",
                                       details: passValidValue)
  
  static let noPropertyValue = FlutterError(code: "14",
                                            message: "Could not find property value",
                                            details: passValidValue)

  static let noSdkInfo = FlutterError(code: "15",
                                      message: "Could not find sdk info",
                                      details: passValidValue)

  static let noLifetime = FlutterError(code: "16",
                                       message: "Could not find lifetime",
                                       details: passValidValue)

  static let serializationError = FlutterError(code: "18",
                                            message: "Failed to serialize response from native bridge",
                                            details: "")
  
  private static func mapQonversionError(_ error: NSError, errorCode: String, errorMessage: String? = nil) -> FlutterError {
    var message = ""
    
    if let errorMessage = errorMessage {
      message = errorMessage + ". "
    }
    message += error.localizedDescription
    
    var details = "Qonversion Error Code: \(error.code)"
    
    if let additionalMessage = error.userInfo[NSDebugDescriptionErrorKey] {
      details = "\(details). Additional Message: \(additionalMessage)"
    }
    
    return FlutterError(code: errorCode,
                        message: message,
                        details: details)
  }
  
  private static func mapSandwichError(_ error: SandwichError, errorCode: String, errorMessage: String? = nil) -> FlutterError {
    var message = ""
    
    if let errorMessage = errorMessage {
      message = errorMessage + ". "
    }
    message += error.details
    
    var details = "Qonversion Error Code: \(error.code)"
    
    if let additionalMessage = error.additionalMessage {
      details = "\(details). Additional Message: \(additionalMessage)"
    }
    
    return FlutterError(code: errorCode,
                        message: message,
                        details: details)
  }
}
